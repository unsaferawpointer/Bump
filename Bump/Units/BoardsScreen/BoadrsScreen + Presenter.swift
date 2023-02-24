//
//  BoadrsScreen + Presenter.swift
//  Bump
//
//  Created by Anton Cherkasov on 20.02.2023.
//

import UIKit

/// Interface of the BoardsScreen presenter
protocol BoardsScreenPresenter {

	/// Load boards
	///
	/// - Parameters:
	///    - boards: Boards
	func load(_ boards: [CHBoard])
}

extension BoardsScreen {

	/// BoardsScreen presenter
	final class Presenter {

		// MARK: - DI

		var stringsFactory: BoardsScreenStringsFactory

		weak var view: BoardsScreenViewController?

		var interactor: BoardsScreenInteractor?

		var output: BoardsScreenOutput?

		/// Only for testing
		private (set) var loadingTask: Task<Void, Never>?

		// MARK: - Initialization

		/// Base initialization
		///
		/// - Parameters:
		///    - output: Output of the unit
		///    - stringsFactory: Storage of the localized strings
		init(output: BoardsScreenOutput? = nil,
			 stringsFactory: BoardsScreenStringsFactory = BoardsScreen.StringsFactory()) {
			self.output = output
			self.stringsFactory = stringsFactory
		}

	}
}

// MARK: - BoardsScreenPresenter
extension BoardsScreen.Presenter: BoardsScreenPresenter {

	@MainActor
	func load(_ boards: [CHBoard]) {
		view?.stopProgressAnimation()
		let snapshot = makeSnapshot(boards)
		view?.load(snapshot)
	}
}

// MARK: - BoardsScreenViewOutput
extension BoardsScreen.Presenter: BoardsScreenViewOutput {

	func viewController(didChangeState state: LifeCycleState) {
		guard case .didLoad = state else {
			return
		}
		view?.configure(title: stringsFactory.title)
		view?.startProgressAnimation()
		fetchBoards()
	}

	func didSelect(_ identifier: String) {
		output?.userSelectBoard(identifier: identifier)
	}
}

// MARK: - Helpers
private extension BoardsScreen.Presenter {

	typealias HeaderModel 	= BoardsScreen.HeaderModel
	typealias CellModel 	= BoardsScreen.CellModel

	func makeSnapshot(_ boards: [CHBoard]) -> NSDiffableDataSourceSnapshot<HeaderModel, CellModel> {
		let sections = Dictionary(grouping: boards) { $0.category }
			.map { (key, boards) in
				guard key.isEmpty else {
					return BoardsScreen.Presenter.BoardsSection(title: key, boards: boards)
				}
				return BoardsScreen.Presenter.BoardsSection(title: stringsFactory.emptyCategory, boards: boards)
			}
			.sorted {
				$0.title < $1.title
			}
		var snapshot = NSDiffableDataSourceSnapshot<BoardsScreen.HeaderModel, BoardsScreen.CellModel>()
		for section in sections {
			let headerModel = BoardsScreen.HeaderModel(title: section.title)
			let cellModels = section.boards.map { board in
				BoardsScreen.CellModel(id: board.id, title: board.name, subtitle: board.info, detail: board.id)
			}
			snapshot.appendSections([headerModel])
			snapshot.appendItems(cellModels, toSection: headerModel)
		}
		return snapshot
	}

	func fetchBoards() {
		guard let interactor else {
			return
		}
		loadingTask = Task {
			do {
				let objects = try await interactor.fetchBoards()
				await load(objects)
			} catch {
				view?.stopProgressAnimation()
			}
		}
	}
}

// MARK: - Nested data structs
private extension BoardsScreen.Presenter {

	struct BoardsSection {

		let title: String

		let boards: [CHBoard]
	}
}
