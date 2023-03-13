//
//  ThreadDetailScreen + PlaceholdersFactory.swift
//  Bump
//
//  Created by Anton Cherkasov on 11.03.2023.
//

import UIKit

/// Interface of the placeholders factory of the threads screen
protocol ThreadDetailScreenPlaceholdersFactory {

	/// Make model for error
	func makeModel(for error: Error) -> ZeroViewModel
}

extension ThreadDetailScreen {

	/// Placeholders factory
	final class PlaceholdersFactory {

		var stringsFactory: ThreadDetailScreenStringsFactory = StringsFactory()
	}
}

// MARK: - ThreadDetailScreenPlaceholdersFactory
extension ThreadDetailScreen.PlaceholdersFactory: ThreadDetailScreenPlaceholdersFactory {

	func makeModel(for error: Error) -> ZeroViewModel {
		switch error {
			case let error as ThreadDetailScreen.Presenter.Error where error == .emptySelection:
				return .init(title: stringsFactory.emptySelectionTitle,
							 message: stringsFactory.emptySelectionMessage,
							 image: UIImage(systemName: "wifi.exclamationmark"))
			default:
				return .init(title: stringsFactory.errorTitle,
							 message: stringsFactory.errorMessage,
							 image: UIImage(systemName: "questionmark.app.dashed"),
							 buttonTitle: stringsFactory.errorButtonTitle)
		}
	}
}
