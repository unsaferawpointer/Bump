//
//  NetworkServiceTests.swift
//  BumpTests
//
//  Created by Anton Cherkasov on 10.02.2023.
//

import XCTest
@testable import Bump

final class NetworkServiceTests: XCTestCase {

	var sut: NetworkService!

	var urlSession: URLSessionFacadeSpy!

	override func setUpWithError() throws {
		try super.setUpWithError()
		sut = NetworkService()
		urlSession = URLSessionFacadeSpy()
		sut.urlSession = urlSession
	}

	override func tearDownWithError() throws {
		urlSession = nil
		sut = nil
		try super.tearDownWithError()
	}

}

// MARK: - NetworkServiceProtocol
extension NetworkServiceTests {

	func testFetchData() async throws {
		// Arrange
		let url = try XCTUnwrap(URL(string: "www.fakehost.com/testpath"))
		let request = RequestStub(path: "/testpath", httpMethod: "POST", url: url)

		urlSession.dataStub = try XCTUnwrap(try JSONEncoder().encode("i_am_data"))
		urlSession.responseStub = try XCTUnwrap(HTTPURLResponse(url: url,
																statusCode: 200,
																httpVersion: "1.1",
																headerFields: nil))
		urlSession.errorStub = nil

		// Act
		let response = try await sut.fetchObject(request)

		// Assert
		XCTAssertEqual(response, "i_am_data")
		guard case let .data(request) = urlSession.invocations.first else {
			return XCTFail("`data(request:) method must be invocked")
		}
		XCTAssertEqual(request.url, url)
		XCTAssertEqual(request.httpMethod, "POST")

	}

	func testFetchObjectWhenServerErrorHasOccured() async throws {
		// Arrange
		let url = try XCTUnwrap(URL(string: "www.fakehost.com/testpath"))
		let request = RequestStub(path: "/testpath", httpMethod: "POST", url: url)

		urlSession.dataStub = Data()
		urlSession.responseStub = try XCTUnwrap(HTTPURLResponse(url: url,
																statusCode: 403,
																httpVersion: "1.1",
																headerFields: nil))
		urlSession.errorStub = nil

		var expectedError: NetworkService.Error?

		// Act
		do {
			let _ = try await sut.fetchObject(request)
		} catch {
			expectedError = error as? NetworkService.Error
		}

		// Assert
		XCTAssertEqual(expectedError, .serverError)
	}

	func testFetchObjectWhenInvalidResponseFormatErrorHasOccured() async throws {
		// Arrange
		let url = try XCTUnwrap(URL(string: "www.fakehost.com/testpath"))
		let request = RequestStub(path: "/testpath", httpMethod: "POST", url: url)

		urlSession.dataStub = Data()
		urlSession.responseStub = try XCTUnwrap(HTTPURLResponse(url: url,
																statusCode: 200,
																httpVersion: "1.1",
																headerFields: nil))
		urlSession.errorStub = nil

		var expectedError: NetworkService.Error?

		// Act
		do {
			let _ = try await sut.fetchObject(request)
		} catch {
			expectedError = error as? NetworkService.Error
		}

		// Assert
		XCTAssertEqual(expectedError, .invalidResponseFormat)
	}
}

// MARK: - Nested data structs
extension NetworkServiceTests {

	struct RequestStub: Request {

		typealias Response = String

		var path: String

		var httpMethod: String

		var url: URL

	}
}
