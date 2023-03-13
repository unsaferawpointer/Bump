//
//  NetworkService.swift
//  UITableView-Adapter
//
//  Created by Anton Cherkasov on 09.01.2023.
//

import Foundation

/// Interface of the network service
protocol NetworkServiceProtocol {
	func fetchObject<T: Request, Response>(_ endpoint: T) async throws -> Response where Response == T.Response
}

/// Network service
final class NetworkService {

	var urlSession: URLSessionFacadeProtocol = URLSession.shared
}

// MARK: - NetworkServiceProtocol
extension NetworkService: NetworkServiceProtocol {

	func fetchObject<T, Response>(_ endpoint: T) async throws -> Response where T : Request, Response == T.Response {

		var request = URLRequest(url: endpoint.url)
		request.httpMethod = endpoint.httpMethod

		let (data, response) = try await urlSession.data(for: request)

		print("response \((response as? HTTPURLResponse)?.statusCode)")
		guard let httpResponse = response as? HTTPURLResponse,
			  (200...299).contains(httpResponse.statusCode) else {
			throw Error.serverError
		}

		let decoder = JSONDecoder()
		guard let object = try? decoder.decode(Response.self, from: data) else {
			throw Error.invalidResponseFormat
		}

		return object
	}
}

// MARK: - Nested data structs
extension NetworkService {

	/// Network service error
	enum Error: Swift.Error {
		case invalidResponseFormat
		case internalError
		case serverError
	}
}
