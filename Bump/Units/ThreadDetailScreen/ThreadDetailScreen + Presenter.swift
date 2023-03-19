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

		// MARK: - DI

		weak var view: ThreadDetailScreenViewController?

		var interactor: ThreadDetailScreenInteractor?


		var title: String = ""

		// MARK: - Initialization

		/// Base initialization
		init() { }
	}
}

// MARK: - ThreadDetailScreenViewOutput
extension ThreadDetailScreen.Presenter: ThreadDetailScreenViewOutput {

	func viewController(didChangeState state: LifeCycleState) {

		switch state {
			case .didLoad:
				interactor?.fetchThreads()
				view?.configure(title: title)
			case .willAppear:
				break
			case .didDisappear:
				interactor?.cancelFetching()
			default:
				fatalError("Can`t handle lifecycle state")
		}
	}

	func refreshData() {
		interactor?.fetchThreads()
	}
}

// MARK: - Helpers
extension ThreadDetailScreen.Presenter {

	typealias CellModel 	= ThreadDetailScreen.PostModel
	typealias Snapshot 		= NSDiffableDataSourceSnapshot<String, ThreadDetailScreen.PostModel>

	enum Error: Swift.Error {
		case emptySelection
	}

	func makeSnapshot(_ models: [CellModel]) -> Snapshot {
		var snapshot = NSDiffableDataSourceSnapshot<String, ThreadDetailScreen.PostModel>()
		snapshot.appendSections([""])
		snapshot.appendItems(models, toSection: "")
		return snapshot
	}

}

// MARK: - ThreadDetailScreenInteractorOutput
extension ThreadDetailScreen.Presenter: ThreadDetailScreenInteractorOutput {

	func reload(_ models: [PostModel]) {
		view?.stopProgressAnimation()
		let snapshot = makeSnapshot(models)
		view?.configure(snapshot: snapshot)
	}

	func performTransition(to post: Int) {
		view?.scrollTo(postNumber: post)
	}

	func startLoading() {
		view?.startProgressAnimation()
	}

	func stopLoading() {
		view?.stopProgressAnimation()
	}
}
