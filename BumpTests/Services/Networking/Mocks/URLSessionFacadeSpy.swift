//
//  URLSessionFacadeMock.swift
//  BumpTests
//
//  Created by Anton Cherkasov on 10.02.2023.
//

import Foundation
@testable import Bump

final class URLSessionFacadeSpy {

	var dataStub = Data()
	var responseStub = HTTPURLResponse()

	var errorStub: Error?

	var invocations: [Action] = []

}

// MARK: - URLSessionFacadeProtocol
extension URLSessionFacadeSpy: URLSessionFacadeProtocol {

	func data(for request: URLRequest) async throws -> (Data, URLResponse) {

		let action: Action = .data(request: request)
		invocations.append(action)

		guard let error = errorStub else {
			return (dataStub, responseStub)
		}
		throw error
	}
}

// MARK: - Nested data structs
extension URLSessionFacadeSpy {

	enum Action {
		case data(request: URLRequest)
	}
}
