//
//  BoardsScreen.swift
//  Bump
//
//  Created by Anton Cherkasov on 20.02.2023.
//

import UIKit

/// Unit of the boards screen
struct BoardsScreen { }

/// Interface of the boards unit delegate
protocol BoardsScreenOutput: AnyObject {
	func unitInvockedAction(_ action: BoardsScreen.Action)
}

// MARK: - Public interface
extension BoardsScreen {

	static func makeScreen(output: BoardsScreenOutput) -> UIViewController {
		return ViewController { viewController in
			let presenter = Presenter(output: output)
			let interactor = Interactor()
			presenter.interactor = interactor
			viewController.presenter = presenter
			presenter.view = viewController
		}
	}

}

// MARK: - Nested data structs
extension BoardsScreen {

	/// Output actions
	enum Action {
		/// User selected the a board
		case userSelectedBoard(_ identifier: String)
	}
}
