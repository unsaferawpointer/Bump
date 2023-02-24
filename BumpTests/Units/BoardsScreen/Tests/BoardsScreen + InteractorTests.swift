//
//  BoardsScreen + InteractorTests.swift
//  BumpTests
//
//  Created by Anton Cherkasov on 24.02.2023.
//

import XCTest
@testable import Bump

final class BoardsScreenInteractorTests: XCTestCase {

	var sut: BoardsScreen.Interactor!

	var networkService: NetworkServiceMock!

	override func setUpWithError() throws {
		sut = BoardsScreen.Interactor()

		networkService = NetworkServiceMock()
		sut.networkService = networkService
	}

	override func tearDownWithError() throws {
		sut = nil
		networkService = nil
	}

}

// MARK: - BoardsScreenInteractor cases
extension BoardsScreenInteractorTests {

	func testFetchBoards() async throws {

		// Arrange
		networkService.responsesStorage[ObjectIdentifier(BoardsEndpoint.self)] = [makeBoard(id: "news", category: "Politics"),
																				  makeBoard(id: "po", category: "Politics")]

		// Act
		let boards = try await sut.fetchBoards()

		// Assert
		XCTAssertEqual(boards.count, 2)
	}
}

// MARK: - Helpers
extension BoardsScreenInteractorTests {

	func makeBoard(id: String, category: String) -> CHBoard {
		return .init(id: id,
					 name: "Name",
					 category: category,
					 info: "Info",
					 threads_per_page: 100,
					 bump_limit: 100,
					 max_pages: 100,
					 default_name: "Default name")
	}
}

// MARK: - Nested data structs
extension BoardsScreenInteractorTests {

	final class BoardsScreenStringsFactoryMock: BoardsScreenStringsFactory {

		var title: String = ""
		var emptyCategory: String = ""
	}

	final class BoardsScreenOutputMock: BoardsScreenOutput {

		var invocations: [Action] = []

		func userSelectBoard(identifier: String) {
			invocations.append(.userSelectBoard(identifier: identifier))
		}

		enum Action {
			case userSelectBoard(identifier: String)
		}
	}
}
