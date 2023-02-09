//
//  Board.swift
//  Bump
//
//  Created by Anton Cherkasov on 09.01.2023.
//

import Foundation

/// Response model of the board
struct CHBoard: Codable {

	// MARK: - Required

	var id: String
	var name: String
	var category: String
	var info: String
	var threads_per_page: Int
	var bump_limit: Int
	var max_pages: Int
	var default_name: String

}

// MARK: - CustomStringConvertible
extension CHBoard: CustomStringConvertible {

	var description: String {
		return "\n" +
			   "Board:\n" +
			   "    id = \(id)\n" +
			   "    name = \(name)\n" +
			   "    category = \(category)\n"
	}
}
