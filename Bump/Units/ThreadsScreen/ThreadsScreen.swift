//
//  ThreadsScreen.swift
//  Bump
//
//  Created by Anton Cherkasov on 24.02.2023.
//

import UIKit

/// Unit of the threads screen
struct ThreadsScreen { }

/// Interface of the threads screen delegate
protocol ThreadsScreenOutput: AnyObject {
	func unitInvockedAction(_ action: ThreadsScreen.Action)
}

// MARK: - Public interface
extension ThreadsScreen {

	static func makeScreen(board: String, output: ThreadsScreenOutput) -> UIViewController {
		return ViewController { viewController in
			let payload = Payload(boardIdentifier: board)
			let presenter = Presenter(payload, output: output)
			let interactor = Interactor()
			presenter.interactor = interactor
			viewController.presenter = presenter
			presenter.view = viewController
		}
	}
}

// MARK: - Nested data structs
extension ThreadsScreen {

	enum Action {
		case userSelectedThread(board: String, thread: Int)
	}
}
