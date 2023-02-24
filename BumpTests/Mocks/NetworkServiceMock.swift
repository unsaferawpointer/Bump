//
//  NetworkServiceMock.swift
//  BumpTests
//
//  Created by Anton Cherkasov on 24.02.2023.
//

@testable import Bump

final class NetworkServiceMock: NetworkServiceProtocol {

	var responsesStorage: [ObjectIdentifier: Decodable] = [:]

	var error: Error?

	func fetchObject<T, Response>(_ endpoint: T) async throws -> Response where T : Request, Response == T.Response {
		if let error {
			throw error
		}
		guard let response = responsesStorage[ObjectIdentifier(T.self)] as? Response else {
			fatalError("Please, configure responses storage")
		}
		return response
	}
}
