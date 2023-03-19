//
//  DeeplinkManagerTests.swift
//  BumpTests
//
//  Created by Anton Cherkasov on 28.03.2023.
//

import XCTest
@testable import Bump

final class DeeplinkManagerTests: XCTestCase {

	var sut: DeeplinkManager!

	override func setUpWithError() throws {
		sut = DeeplinkManager(scheme: "deeplink")
	}

	override func tearDownWithError() throws {
		sut = nil
	}

}

// MARK: - Tests cases
extension DeeplinkManagerTests {

	func testMakeDeeplinkIfPossibleWhenDeeplinkIsThread() throws {
		// Arrange
		let url = try XCTUnwrap(URL(string: "applewebdata:/news/res/14611560.html#14611560"))

		// Act
		let result = sut.makeDeeplinkIfPossible(url)

		// Assert
		guard case let .thread(board, thread) = result else {
			return XCTFail("Invalid endpoint")
		}

		XCTAssertEqual(board, "news")
		XCTAssertEqual(thread, 14611560)
	}

	func testMakeDeeplinkIfPossibleWhenDeeplinkIsPost() throws {
		// Arrange
		let url = try XCTUnwrap(URL(string: "applewebdata:/news/res/14611560.html#14612046"))

		// Act
		let result = sut.makeDeeplinkIfPossible(url)

		// Assert
		guard case let .post(board, thread, post) = result else {
			return XCTFail("Invalid endpoint")
		}

		XCTAssertEqual(board, "news")
		XCTAssertEqual(thread, 14611560)
		XCTAssertEqual(post, 14612046)
	}
}
