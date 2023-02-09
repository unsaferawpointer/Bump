//
//  Request.swift
//  Bump
//
//  Created by Anton Cherkasov on 09.02.2023.
//

import Foundation

/// Interface of the network request
protocol Request {

	associatedtype Response: Decodable

	var path: String { get }

	var url: URL { get }

	var httpMethod: String { get }

}

// MARK: - Properties by-default
extension Request {

	var url: URL {

		var components = URLComponents()
		components.scheme = "https"
		components.host = "2ch.hk"
		components.path = "/" + path

		guard let url = components.url else {
			preconditionFailure(
				"Invalid URL components: \(components)"
			)
		}

		return url
	}
}
