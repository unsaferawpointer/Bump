//
//  BoardsEndpoint.swift
//  Bump
//
//  Created by Anton Cherkasov on 11.02.2023.
//

import Foundation

/// Enpoint of all boards
struct BoardsEndpoint { }

// MARK: - Request
extension BoardsEndpoint: Request {

	typealias Response = [CHBoard]

	var path: String {
		return "api/mobile/v2/boards"
	}

	var httpMethod: String {
		return HTTPMethod.get.stringValue
	}
}
