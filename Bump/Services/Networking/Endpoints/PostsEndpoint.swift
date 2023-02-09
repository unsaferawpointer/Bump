//
//  PostsEndpoint.swift
//  Bump
//
//  Created by Anton Cherkasov on 11.02.2023.
//

import Foundation

/// All posts for specific board and thread
struct PostsEndpoint {

	/// Board identifier
	let board: String

	/// Number of the thread
	let thread: Int

	/// Initialization
	///
	/// - Parameters:
	///    - board: Identifier of the board
	///    - thread: Identifier of the thread
	init(board: String, thread: Int) {
		self.board = board
		self.thread = thread
	}

}

// MARK: - Request
extension PostsEndpoint: Request {

	typealias Response = CHThreadDetailResponse

	var path: String {
		return "\(board)/res/\(thread).json"
	}

	var httpMethod: String {
		return HTTPMethod.get.stringValue
	}
}
