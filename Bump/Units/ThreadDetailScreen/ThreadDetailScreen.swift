//
//  ThreadDetailScreen.swift
//  Bump
//
//  Created by Anton Cherkasov on 11.03.2023.
//

import UIKit

/// Unit of the posts screen
struct ThreadDetailScreen { }

/// Interface of the posts screen builder
protocol ThreadDetailScreenBuilder {

	/// - Parameters:
	///    - payload: Payload of the unit
	/// - Returns: Screen of the posts
	func build(_ payload: ThreadDetailScreen.Payload) -> UIViewController
}

// MARK: - ThreadDetailScreenBuilder
extension ThreadDetailScreen: ThreadDetailScreenBuilder {

	func build(_ payload: ThreadDetailScreen.Payload) -> UIViewController {
		return ThreadDetailScreen.ViewController { viewController in
			let presenter = Presenter(payload)
			let interactor = Interactor()
			presenter.interactor = interactor
			viewController.presenter = presenter
			presenter.view = viewController
		}
	}
}

// MARK: - Nested data structs
extension ThreadDetailScreen {

	/// Payload of the unit
	struct Payload: Equatable{

		var boardIdentifier: String

		var boardName: String

		var thread: Int
	}
}
