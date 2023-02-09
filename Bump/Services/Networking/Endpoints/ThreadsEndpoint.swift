//
//  ThreadsEndpoint.swift
//  Bump
//
//  Created by Anton Cherkasov on 11.02.2023.
//

import Foundation

/// All threads for specific board sorted by last post
struct ThreadsEndpoint {

	/// Board Identifier
	let board: String

	/// Initialization
	///
	/// - Parameters:
	///    - board: Identifier of the thread
	init(board: String) {
		self.board = board
	}

}

// MARK: - Request
extension ThreadsEndpoint: Request {

	typealias Response = CHThreadsResponse

	var path: String {
		return "\(board)/catalog.json"
	}

	var httpMethod: String {
		return HTTPMethod.get.stringValue
	}
}
