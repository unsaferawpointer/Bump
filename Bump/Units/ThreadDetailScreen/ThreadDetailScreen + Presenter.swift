//
//  ThreadDetailScreen + Presenter.swift
//  Bump
//
//  Created by Anton Cherkasov on 11.03.2023.
//

import UIKit

extension ThreadDetailScreen {

	/// ThreadDetailScreen presenter
	final class Presenter {

		var payload: ThreadDetailScreen.Payload? {
			didSet {
				guard oldValue != payload else {
					return
				}
				refreshData()
			}
		}

		// MARK: - DI

		var stringsFactory: ThreadDetailScreenStringsFactory = StringsFactory()

		var placeholdersFactory: ThreadDetailScreenPlaceholdersFactory = PlaceholdersFactory()

		weak var view: ThreadDetailScreenViewController?

		var interactor: ThreadDetailScreenInteractor?

		/// Only for testing
		private (set) var loadingTask: Task<Void, Never>?

		// MARK: - Initialization

		/// Base initialization
		///
		/// - Parameters:
		///    - payload: payload of the ThreadDetailScreen unit
		init(_ payload: ThreadDetailScreen.Payload? = nil) {
			self.payload = payload
		}
	}
}

// MARK: - ThreadDetailScreenViewOutput
extension ThreadDetailScreen.Presenter: ThreadDetailScreenViewOutput {

	func viewController(didChangeState state: LifeCycleState) {
		guard case .didLoad = state else {
			return
		}
		view?.configure(title: payload?.boardName ?? "")
		fetchThreads { [weak view] in
			view?.startProgressAnimation()
		} postAction: { [weak view] in
			view?.stopProgressAnimation()
		}
	}

	func refreshData() {
		fetchThreads()
	}
}

// MARK: - Helpers
extension ThreadDetailScreen.Presenter {

	typealias CellModel 	= ThreadDetailScreen.CellModel
	typealias Snapshot 		= NSDiffableDataSourceSnapshot<String, ThreadDetailScreen.CellModel>

	enum Error: Swift.Error {
		case emptySelection
	}

	func makeSnapshot(_ response: CHThreadDetailResponse) -> Snapshot {
		guard let payload = response.threadPayload.first else {
			return .init()
		}
		let posts = payload.posts
			.sorted { lhs, rhs in
				lhs.num < rhs.num
			}
			.map {
				CellModel(id: $0.num,
						  likes: $0.likes ?? 0,
						  dislikes: $0.dislikes ?? 0,
						  body: $0.comment,
						  date: Date(timeIntervalSince1970: TimeInterval($0.timestamp)))
			}

		var snapshot = NSDiffableDataSourceSnapshot<String, ThreadDetailScreen.CellModel>()
		snapshot.appendSections([""])
		snapshot.appendItems(posts, toSection: "")
		return snapshot
	}

	func fetchThreads(preAction: (() -> Void)? = nil, postAction: (() -> Void)? = nil) {
		guard
			let boardIdentifier = payload?.boardIdentifier,
			let thread = payload?.thread, let interactor
		else {
			view?.load(.init())
			let model = makeModel(for: Error.emptySelection)
			view?.configurePlaceholder(model: model)
			return
		}

		preAction?()
		loadingTask = Task {
			let result = await interactor.fetchThreads(for: boardIdentifier, thread: thread)
			await processResult(result: result, postAction: postAction)
		}
	}

	@MainActor
	func processResult(result: Result<CHThreadDetailResponse, Swift.Error>, postAction: (() -> Void)?) {
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
		var model = placeholdersFactory.makeModel(for: Error.emptySelection)
		model.action = { [weak self] in
			self?.view?.configurePlaceholder(model: nil)
			self?.fetchThreads { [weak self] in
				self?.view?.startProgressAnimation()
			} postAction: { [weak self] in
				self?.view?.stopProgressAnimation()
			}
		}
		return model
	}
}
