//
//  ThreadsScreen + PresenterTests.swift
//  BumpTests
//
//  Created by Anton Cherkasov on 26.02.2023.
//

import XCTest
@testable import Bump

final class ThreadsScreenPresenterTests: XCTestCase {

	var sut: ThreadsScreen.Presenter!

	var view: ThreadsScreenViewControllerMock!

	var interactor: ThreadsScreenInteractorMock!

	var placeholdersFactory: ThreadsScreenPlaceholdersFactoryMock!

	var output: ThreadsScreenOutputSpy!

	override func setUpWithError() throws {

		output = ThreadsScreenOutputSpy()

		sut = ThreadsScreen.Presenter(.init(boardIdentifier: "news"), output: output)

		interactor = ThreadsScreenInteractorMock()
		sut.interactor = interactor

		view = ThreadsScreenViewControllerMock()
		sut.view = view

		placeholdersFactory = ThreadsScreenPlaceholdersFactoryMock()
		sut.placeholdersFactory = placeholdersFactory
	}

	override func tearDownWithError() throws {
		sut = nil
		view = nil
		interactor = nil
		output = nil
		placeholdersFactory = nil
	}

}

// MARK: - ThreadsScreenViewOutput cases
extension ThreadsScreenPresenterTests {

	func testViewControllerDidChangeStateWhenStateIsDidLoad() async throws {
		// Arrange
		interactor.error = nil
		interactor.threadsResponseStub = makeThreadsResponse()

		let payload = ThreadsScreen.Payload(boardIdentifier: "news")
		sut = ThreadsScreen.Presenter(payload, output: output)
		sut.interactor = interactor
		sut.view = view

		// Act
		sut.viewController(didChangeState: .didLoad)
		let _ = await sut.loadingTask?.result

		// Assert

		guard case let .configure(title) = view.invocations[0] else {
			return XCTFail("`configure` must be invocked")
		}
		XCTAssertEqual(title, "news")

		guard case .startProgressAnimation = view.invocations[1] else {
			return XCTFail("`startProgressAnimation` must be invocked")
		}

		guard case .stopProgressAnimation = view.invocations[2] else {
			return XCTFail("`stopProgressAnimation` must be invocked")
		}

		guard case let .load(snapshot) = view.invocations[3] else {
			return XCTFail("`load` must be invocked")
		}

		XCTAssertEqual(snapshot.numberOfSections, 1)
		XCTAssertEqual(snapshot.numberOfItems, 4)

		guard case let .configurePlaceholder(model) = view.invocations[4] else {
			return XCTFail("`configurePlaceholder` must be invocked")
		}

		XCTAssertNil(model)
	}

	func testViewControllerDidChangeStateWhenSelectionIsEmpty() async throws {
		// Arrange
		interactor.error = nil
		interactor.threadsResponseStub = makeThreadsResponse()

		sut = ThreadsScreen.Presenter(nil, output: output)
		sut.interactor = interactor
		sut.view = view

		// Act
		sut.viewController(didChangeState: .didLoad)
		let _ = await sut.loadingTask?.result

		// Assert

		guard case let .configure(title) = view.invocations[0] else {
			return XCTFail("`configure` must be invocked")
		}
		XCTAssertEqual(title, "")

		guard case let .load(snapshot) = view.invocations[1] else {
			return XCTFail("`load` must be invocked")
		}

		XCTAssertEqual(snapshot.numberOfSections, 0)
		XCTAssertEqual(snapshot.numberOfItems, 0)

		guard case let .configurePlaceholder(model) = view.invocations[2] else {
			return XCTFail("`configurePlaceholder` must be invocked")
		}

		XCTAssertNotNil(model)
	}

	func testViewControllerDidChangeStateWhenStateIsDidLoadWhenErrorHasOccured() async throws {
		// Arrange
		interactor.error = FakeError()
		interactor.threadsResponseStub = nil

		let payload = ThreadsScreen.Payload(boardIdentifier: "news")
		sut = ThreadsScreen.Presenter(payload, output: output)
		sut.interactor = interactor
		sut.view = view

		// Act
		sut.viewController(didChangeState: .didLoad)
		let _ = await sut.loadingTask?.result

		// Assert

		guard case let .configure(title) = view.invocations[0] else {
			return XCTFail("`configure` must be invocked")
		}
		XCTAssertEqual(title, "news")

		guard case .startProgressAnimation = view.invocations[1] else {
			return XCTFail("`startProgressAnimation` must be invocked")
		}

		guard case .stopProgressAnimation = view.invocations[2] else {
			return XCTFail("`stopProgressAnimation` must be invocked")
		}

		guard case let .load(snapshot) = view.invocations[3] else {
			return XCTFail("`load` must be invocked")
		}

		XCTAssertEqual(snapshot.numberOfSections, 0)
		XCTAssertEqual(snapshot.numberOfItems, 0)

		guard case let .configurePlaceholder(model) = view.invocations[4] else {
			return XCTFail("`configurePlaceholder` must be invocked")
		}

		XCTAssertNotNil(model)

	}

	func testTouchUpInsideZeroScreenButton() async throws {
		// Arrange
		interactor.error = FakeError()
		interactor.threadsResponseStub = nil

		let payload = ThreadsScreen.Payload(boardIdentifier: "news")
		sut = ThreadsScreen.Presenter(payload, output: output)
		sut.interactor = interactor
		sut.view = view

		sut.viewController(didChangeState: .didLoad)
		let _ = await sut.loadingTask?.result

		guard case let .configurePlaceholder(model) = view.invocations[4] else {
			return XCTFail("`configurePlaceholder` must be invocked")
		}

		// Act
		model?.action?()

		
	}

	func testDidSelect() async throws {
		// Arrange
		let payload = ThreadsScreen.Payload(boardIdentifier: "news")
		sut = ThreadsScreen.Presenter(payload, output: output)
		sut.threads = [.init(num: 0, board: "news", timestamp: 9999999)]

		// Act
		sut.didSelect(0)

		// Assert
		guard case let .unitInvockedAction(action) = output.invocations[0] else {
			return XCTFail("`unitInvockedAction` must be invocked")
		}

		guard case let .userSelectedThread(board, thread) = action else {
			return XCTFail("`userSelectedThread` must be invocked")
		}

		XCTAssertEqual(thread, 0)
		XCTAssertEqual(board, "news")
	}
}

// MARK: - Helpers
extension ThreadsScreenPresenterTests {

	typealias CHThread = CHThreadsResponse.CHThread

	func makeThreadsResponse() -> CHThreadsResponse {
		let threads: [CHThread] = [.init(num: 0, board: "news", timestamp: 1),
								   .init(num: 1, board: "news", timestamp: 4),
								   .init(num: 2, board: "news", timestamp: 2),
								   .init(num: 3, board: "news", timestamp: 3)]
		return .init(threads: threads)
	}

	func makeBoard(id: String, name: String, category: String) -> CHBoard {
		return .init(id: id,
					 name: name,
					 category: category,
					 info: "Info",
					 threads_per_page: 100,
					 bump_limit: 100,
					 max_pages: 100,
					 default_name: "Default name")
	}
}

// MARK: - Nested data structs
extension ThreadsScreenPresenterTests {

	final class ThreadsScreenOutputSpy: ThreadsScreenOutput {

		var invocations: [Action] = []

		enum Action {
			case unitInvockedAction(_ action: ThreadsScreen.Action)
		}

		func unitInvockedAction(_ action: ThreadsScreen.Action) {
			invocations.append(.unitInvockedAction(action))
		}
	}
}
