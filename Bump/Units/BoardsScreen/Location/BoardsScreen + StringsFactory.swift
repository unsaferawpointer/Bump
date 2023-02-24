//
//  BoardsScreen + StringsFactory.swift
//  Bump
//
//  Created by Anton Cherkasov on 23.02.2023.
//

import UIKit
import Foundation

/// Interface of the strings factory for BoardsScreen unit
protocol BoardsScreenStringsFactory {

	/// Title of the ViewController
	var title: String { get }

	/// Placeholder of the empty header
	var emptyCategory: String { get }
}

extension BoardsScreen {

	/// Strings factory for BoardsScreen unit
	final class StringsFactory { }
}

// MARK: - BoardsScreenStringsFactory
extension BoardsScreen.StringsFactory: BoardsScreenStringsFactory {

	var title: String {
		return "Boards"
	}

	var emptyCategory: String {
		return "Without category"
	}
}
