//
//  CoordinatorTests.swift
//  BumpTests
//
//  Created by Anton Cherkasov on 19.03.2023.
//

import XCTest
@testable import Bump

final class CoordinatorTests: XCTestCase {

	var sut: Coordinator!

	var router: RouterSpy!

	override func setUpWithError() throws {
		router = RouterSpy()
		sut = Coordinator(router: router)
	}

	override func tearDownWithError() throws {
		router = nil
		sut = nil
	}

}

// MARK: - Coordinatable test - cases
extension CoordinatorTests {

	func testStart() throws {

	}
}

// MARK: - BoardsScreenOutput test-cases
extension CoordinatorTests {

	func testUserSelectBoard() throws {

	}
}

// MARK: - ThreadsScreenOutput test-cases
extension CoordinatorTests {

	func testUserSelectThread() throws {

	}
}
