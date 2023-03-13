//
//  ThreadDetailScreen + StringsFactory.swift
//  Bump
//
//  Created by Anton Cherkasov on 11.03.2023.
//


import Foundation

/// Interface of the strings factory for posts screen unit
protocol ThreadDetailScreenStringsFactory {

	/// Title of the common error
	var errorTitle: String { get }

	/// Message of the common error
	var errorMessage: String { get }

	///
	var errorButtonTitle: String { get }

	var emptySelectionTitle: String { get }

	var emptySelectionMessage: String { get }

}

extension ThreadDetailScreen {

	/// Strings factory for posts screen unit
	final class StringsFactory { }
}

// MARK: - ThreadDetailScreenStringsFactory
extension ThreadDetailScreen.StringsFactory: ThreadDetailScreenStringsFactory {

	var emptySelectionTitle: String {
		"No selection"
	}

	var emptySelectionMessage: String {
		"Please, select a thread"
	}

	var errorTitle: String {
		"Failed to load posts"
	}

	var errorMessage: String {
		"Please, try again."
	}

	var errorButtonTitle: String {
		"Update"
	}
}
