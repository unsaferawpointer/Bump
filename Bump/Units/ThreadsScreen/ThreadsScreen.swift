//
//  ThreadsScreen.swift
//  Bump
//
//  Created by Anton Cherkasov on 24.02.2023.
//

import UIKit

/// Unit of the threads screen
struct ThreadsScreen { }

extension ThreadsScreen {

	/// Build unit
	///
	/// - Parameters:
	///    - board: Board
	///    - output: Delegate of the ThreadsScreen unit
	/// - Returns: Threads screen
	func build(board: CHBoard?, output: ThreadsScreenOutput?) -> UIViewController {
		return ThreadsScreen.ViewController { viewController in
			let presenter = Presenter(board: board)
			presenter.output = output
			let interactor = Interactor()
			presenter.interactor = interactor
			viewController.presenter = presenter
			presenter.view = viewController
		}
	}
}

/// Interface of the ThreadsScreen unit
protocol ThreadsScreenOutput {

	/// User select thread
	///
	/// - Parameters:
	///    - identifier: Identifier of the selected thread
	func userSelectThread(identifier: Int)
}
