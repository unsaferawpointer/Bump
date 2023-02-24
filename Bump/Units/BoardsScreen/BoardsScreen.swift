//
//  BoardsScreen.swift
//  Bump
//
//  Created by Anton Cherkasov on 20.02.2023.
//

import UIKit

/// Unit of the boards screen
struct BoardsScreen { }

// MARK: - ViewRepresentable
extension BoardsScreen: ViewRepresentable {

	func toPresent() -> UIViewController {
		return BoardsScreen.ViewController { viewController in
			let presenter = Presenter()
			let interactor = Interactor()
			presenter.interactor = interactor
			viewController.presenter = presenter
			presenter.view = viewController
		}
	}
}

/// Interface of the BoardsScreen unit
protocol BoardsScreenOutput {

	/// User select board
	///
	/// - Parameters:
	///    - identifier: Identifier of the selected board
	func userSelectBoard(identifier: String)
}
