//
//  ThreadsScreen + ScreensFactory.swift
//  Bump
//
//  Created by Anton Cherkasov on 28.02.2023.
//

import UIKit

/// Interface of the placeholders factory of the threads screen
protocol ThreadsScreenPlaceholdersFactory {

	/// Make model for error
	func makeModel(for error: Error, action: @escaping () -> Void) -> ZeroViewModel
}

extension ThreadsScreen {

	/// Placeholders factory
	final class PlaceholdersFactory {

		var stringsFactory: ThreadsScreenStringsFactory = StringsFactory()
	}
}

// MARK: - ThreadsScreenPlaceholdersFactory
extension ThreadsScreen.PlaceholdersFactory: ThreadsScreenPlaceholdersFactory {

	func makeModel(for error: Error, action: @escaping () -> Void) -> ZeroViewModel {
		switch error {
			case let error as ThreadsScreen.Presenter.Error where error == .emptySelection:
				return .init(title: stringsFactory.emptySelectionTitle,
							 message: stringsFactory.emptySelectionMessage,
							 image: UIImage(systemName: "wifi.exclamationmark"))
			default:
				return .init(title: stringsFactory.errorTitle,
							 message: stringsFactory.errorMessage,
							 image: UIImage(systemName: "questionmark.app.dashed"),
							 action: action, buttonTitle: stringsFactory.errorButtonTitle)
		}
	}
}
