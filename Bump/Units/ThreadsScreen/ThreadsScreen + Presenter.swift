//
//  ThreadsScreen + Presenter.swift
//  Bump
//
//  Created by Anton Cherkasov on 24.02.2023.
//

import UIKit

extension ThreadsScreen {

	/// ThreadsScreen presenter
	final class Presenter {

		var payload: Payload? {
			didSet {
				view?.configure(title: payload?.boardIdentifier ?? "")
				refreshData()
			}
		}

		var threads: [CHThreadsResponse.CHThread] = []

		// MARK: - DI

		var stringsFactory: ThreadsScreenStringsFactory = StringsFactory()

		var placeholdersFactory: ThreadsScreenPlaceholdersFactory = PlaceholdersFactory()

		weak var view: ThreadsScreenViewController?

		var interactor: ThreadsScreenInteractor?

		weak var output: ThreadsScreenOutput?

		/// Only for testing
		private (set) var loadingTask: Task<Void, Never>?

		// MARK: - Initialization

		/// Base initialization
		///
		/// - Parameters:
		///    - board: Selected board
		///    - output: Output of the unit
		init(_ payload: Payload?, output: ThreadsScreenOutput) {
			self.payload = payload
			self.output = output
		}
	}
}

// MARK: - ThreadsScreenViewOutput
extension ThreadsScreen.Presenter: ThreadsScreenViewOutput {

	func viewController(didChangeState state: LifeCycleState) {
		guard case .didLoad = state else {
			return
		}
		view?.configure(title: payload?.boardIdentifier ?? "")
		fetchThreads { [weak view] in
			view?.startProgressAnimation()
		} postAction: { [weak view] in
			view?.stopProgressAnimation()
		}

	}

	func didSelect(_ identifier: Int) {
		let thread = threads.first(where: { thread in
			thread.num == identifier
		})

		guard let thread else {
			return
		}
		output?.unitInvockedAction(.userSelectedThread(board: thread.board, thread: identifier))
	}

	func refreshData() {
		fetchThreads()
	}
}

// MARK: - Helpers
extension ThreadsScreen.Presenter {

	typealias CellModel 	= ThreadsScreen.CellModel
	typealias Snapshot 		= NSDiffableDataSourceSnapshot<String, ThreadsScreen.CellModel>

	enum Error: Swift.Error {
		case emptySelection
	}

	func makeSnapshot(_ response: CHThreadsResponse) -> Snapshot {
		self.threads = response.threads
			.sorted { lhs, rhs in
				lhs.timestamp > rhs.timestamp
			}

		let models = threads.map { thread in
				CellModel(id: thread.num,
						  title: thread.subject ?? "",
						  replies: thread.postsCount ?? 0,
						  views: thread.views ?? 0)
			}

		var snapshot = NSDiffableDataSourceSnapshot<String, ThreadsScreen.CellModel>()
		snapshot.appendSections([""])
		snapshot.appendItems(models, toSection: "")
		return snapshot
	}

	func fetchThreads(preAction: (() -> Void)? = nil, postAction: (() -> Void)? = nil) {

		guard let interactor else {
			return
		}

		guard let boardIdentifier = payload?.boardIdentifier else {
			view?.load(.init())
			let model = makeModel(for: Error.emptySelection)
			view?.configurePlaceholder(model: model)
			return
		}

		preAction?()
		loadingTask = Task {
			let result = await interactor.fetchThreads(for: boardIdentifier)
			await processResult(result: result, postAction: postAction)
		}
	}

	@MainActor
	func processResult(result: Result<CHThreadsResponse, Swift.Error>, postAction: (() -> Void)?) {
		postAction?()
		switch result {
			case .success(let response):
				let snapshot = self.makeSnapshot(response)
				view?.load(snapshot)
				view?.configurePlaceholder(model: nil)
			case .failure(let error):
				view?.load(.init())
				let model = makeModel(for: error)
				view?.configurePlaceholder(model: model)
		}
	}

	func makeModel(for error: Swift.Error) -> ZeroViewModel {
		return placeholdersFactory.makeModel(for: Error.emptySelection) { [weak self] in
			self?.view?.configurePlaceholder(model: nil)
			self?.fetchThreads { [weak self] in
				self?.view?.startProgressAnimation()
			} postAction: { [weak self] in
				self?.view?.stopProgressAnimation()
			}
		}
	}
}
