//
//  URLSessionFacade.swift
//  Bump
//
//  Created by Anton Cherkasov on 10.02.2023.
//

import Foundation

/// Proxy interface of the URLSession
protocol URLSessionFacadeProtocol {

	/// Convenience method to load data using an URLRequest, creates and resumes an URLSessionDataTask internally.
	///
	/// - Parameter request: The URLRequest for which to load data.
	/// - Returns: Data and response.
	func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

// MARK: - URLSessionFacadeProtocol
extension URLSession: URLSessionFacadeProtocol { }
