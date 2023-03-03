//
//  ThreadsScreen + StringsFactory.swift
//  Bump
//
//  Created by Anton Cherkasov on 26.02.2023.
//

import Foundation

/// Interface of the strings factory for BoardsScreen unit
protocol ThreadsScreenStringsFactory {

	/// Title of the common error
	var errorTitle: String { get }

	/// Message of the common error
	var errorMessage: String { get }

	///
	var errorButtonTitle: String { get }

	var emptySelectionTitle: String { get }

	var emptySelectionMessage: String { get }

}

extension ThreadsScreen {

	/// Strings factory for BoardsScreen unit
	final class StringsFactory { }
}

// MARK: - ThreadsScreenStringsFactory
extension ThreadsScreen.StringsFactory: ThreadsScreenStringsFactory {

	var emptySelectionTitle: String {
		"No data"
	}

	var emptySelectionMessage: String {
		"Please, select a board"
	}

	var errorTitle: String {
		"Failed to load threads"
	}

	var errorMessage: String {
		"Please, try again."
	}

	var errorButtonTitle: String {
		"Update"
	}
}
