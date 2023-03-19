//
//  BoardsCreen + PresenterTests.swift
//  BumpTests
//
//  Created by Anton Cherkasov on 23.02.2023.
//

import XCTest
@testable import Bump

final class BoardsScreenPresenterTests: XCTestCase {

	var sut: BoardsScreen.Presenter!

	var stringsFactory: BoardsScreenStringsFactoryMock!

	var view: BoardsScreenViewControllerMock!

	var interactor: BoardsScreenInteractorMock!

	var output: BoardsScreenOutputSpy!

	override func setUpWithError() throws {

		output = BoardsScreenOutputSpy()

		sut = BoardsScreen.Presenter(output: output)

		interactor = BoardsScreenInteractorMock()
		sut.interactor = interactor

		view = BoardsScreenViewControllerMock()
		sut.view = view

		stringsFactory = BoardsScreenStringsFactoryMock()
		sut.stringsFactory = stringsFactory
	}

	override func tearDownWithError() throws {
		sut = nil
		stringsFactory = nil
		view = nil
		interactor = nil
		output = nil
	}

}

// MARK: - BoardsScreenViewOutput cases
extension BoardsScreenPresenterTests {

	func testViewControllerDidChangeStateWhenStateIsDidLoad() async throws {
		// Arrange
		stringsFactory.title = UUID().uuidString
		stringsFactory.emptyCategory = UUID().uuidString
		interactor.error = nil
		interactor.boardsStub = [makeBoard(id: "news", category: "Politics"),
								 makeBoard(id: "Good girls", category: "adult"),
								 makeBoard(id: "po", category: "Politics"),
								 makeBoard(id: "dev", category: "")]

		// Act
		sut.viewController(didChangeState: .didLoad)
		let _ = await sut.loadingTask?.result

		// Assert

		guard case let .configure(title) = view.invocations[0] else {
			return XCTFail("`configure` must be invocked")
		}
		XCTAssertEqual(title, stringsFactory.title)

		guard case .startProgressAnimation = view.invocations[1] else {
			return XCTFail("`startProgressAnimation` must be invocked")
		}

		guard case .stopProgressAnimation = view.invocations[2] else {
			return XCTFail("`stopProgressAnimation` must be invocked")
		}

		guard case let .load(snapshot) = view.invocations[3] else {
			return XCTFail("`load` must be invocked")
		}

		XCTAssertEqual(snapshot.numberOfSections, 3)
		XCTAssertEqual(snapshot.numberOfItems, 4)

		// Find placeholder for empty title header
		let sections = snapshot.sectionIdentifiers
		let hasEmptyTitlePlaceholder = sections.contains { header in
			header.title == stringsFactory.emptyCategory
		}
		XCTAssertTrue(hasEmptyTitlePlaceholder)
	}

	func testViewControllerDidChangeStateWhenStateIsDidLoadWhenErrorHasOccured() async throws {
		// Arrange
		stringsFactory.title = UUID().uuidString
		stringsFactory.emptyCategory = UUID().uuidString
		interactor.error = FakeError()
		interactor.boardsStub = []

		// Act
		sut.viewController(didChangeState: .didLoad)
		let _ = await sut.loadingTask?.result

		// Assert

		guard case let .configure(title) = view.invocations[0] else {
			return XCTFail("`configure` must be invocked")
		}
		XCTAssertEqual(title, stringsFactory.title)

		guard case .startProgressAnimation = view.invocations[1] else {
			return XCTFail("`startProgressAnimation` must be invocked")
		}

		guard case .stopProgressAnimation = view.invocations[2] else {
			return XCTFail("`stopProgressAnimation` must be invocked")
		}

		XCTAssertEqual(view.invocations.count, 3)

	}

	func testDidSelect() async throws {
		// Arrange
		sut = BoardsScreen.Presenter(output: output)

		// Act
		sut.didSelect("news")

		// Assert

		guard case let .unitInvockedAction(action) = output.invocations[0] else {
			return XCTFail("`unitInvockedAction` must be invocked")
		}

		guard case let .userSelectedBoard(identifier) = action else {
			return XCTFail("`userSelectBoard` must be invocked")
		}

		XCTAssertEqual(identifier, "news")
	}
}

// MARK: - Helpers
extension BoardsScreenPresenterTests {

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
extension BoardsScreenPresenterTests {

	final class BoardsScreenStringsFactoryMock: BoardsScreenStringsFactory {

		var title: String = ""
		var emptyCategory: String = ""
	}

}

// MARK: - Mocks
extension BoardsScreenPresenterTests {

	final class BoardsScreenOutputSpy: BoardsScreenOutput {

		var invocations: [Action] = []

		enum Action {
			case unitInvockedAction(_ action: BoardsScreen.Action)
		}

		func unitInvockedAction(_ action: BoardsScreen.Action) {
			invocations.append(.unitInvockedAction(action))
		}
	}
}
