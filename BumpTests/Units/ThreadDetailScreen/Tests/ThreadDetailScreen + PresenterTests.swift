//
//  ThreadDetailScreen + PresenterTests.swift
//  BumpTests
//
//  Created by Anton Cherkasov on 26.02.2023.
//

import XCTest
@testable import Bump

final class ThreadDetailScreenPresenterTests: XCTestCase {

	private var sut: ThreadDetailScreen.Presenter!

	private var view: ThreadDetailScreenViewControllerMock!

	private var interactor: ThreadDetailScreenInteractorMock!

	private var placeholdersFactory: ThreadDetailScreenPlaceholdersFactoryMock!

	override func setUpWithError() throws {

		sut = ThreadDetailScreen.Presenter(nil)

		interactor = ThreadDetailScreenInteractorMock()
		sut.interactor = interactor

		view = ThreadDetailScreenViewControllerMock()
		sut.view = view

		placeholdersFactory = ThreadDetailScreenPlaceholdersFactoryMock()
		sut.placeholdersFactory = placeholdersFactory
	}

	override func tearDownWithError() throws {
		sut = nil
		view = nil
		interactor = nil
		placeholdersFactory = nil
	}

}

// MARK: - ThreadDetailScreenViewOutput cases
extension ThreadDetailScreenPresenterTests {

	func testViewControllerDidChangeStateWhenStateIsDidLoad() async throws {
		// Arrange
		interactor.error = nil
		interactor.threadDetailResponseStub = makeThreadDetailResponse()

		let payload = makePayload(boardIdentifier: "news", boardName: "News", thread: 124869)
		sut = ThreadDetailScreen.Presenter(payload)
		sut.interactor = interactor
		sut.view = view

		// Act
		sut.viewController(didChangeState: .didLoad)
		let _ = await sut.loadingTask?.result

		// Assert
		guard case let .configure(title) = view.invocations[0] else {
			return XCTFail("`configure` must be invocked")
		}
		XCTAssertEqual(title, payload.boardName)

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
		interactor.threadDetailResponseStub = makeThreadDetailResponse()

		sut = ThreadDetailScreen.Presenter(nil)
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
		interactor.threadDetailResponseStub = nil

		let payload = makePayload(boardIdentifier: "news", boardName: "News", thread: 124869)
		sut = ThreadDetailScreen.Presenter(payload)
		sut.interactor = interactor
		sut.view = view

		// Act
		sut.viewController(didChangeState: .didLoad)
		let _ = await sut.loadingTask?.result

		// Assert

		guard case let .configure(title) = view.invocations[0] else {
			return XCTFail("`configure` must be invocked")
		}
		XCTAssertEqual(title, payload.boardName)

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
		interactor.threadDetailResponseStub = nil

		let payload = makePayload(boardIdentifier: "news", boardName: "News", thread: 124869)
		sut = ThreadDetailScreen.Presenter(payload)
		sut.interactor = interactor
		sut.view = view

		sut.viewController(didChangeState: .didLoad)
		let _ = await sut.loadingTask?.result

		guard case let .configurePlaceholder(model) = view.invocations[4] else {
			return XCTFail("`configurePlaceholder` must be invocked")
		}

		// Act
		model?.action?()

		// Assert
		guard case let .configurePlaceholder(model) = view.invocations[5] else {
			return XCTFail("`configurePlaceholder` must be invocked")
		}
		XCTAssertNil(model)

		guard case .startProgressAnimation = view.invocations[6] else {
			return XCTFail("`startProgressAnimation` must be invocked")
		}

		let _ = await sut.loadingTask?.result

		guard case .stopProgressAnimation = view.invocations[7] else {
			return XCTFail("`stopProgressAnimation` must be invocked")
		}

		guard case .load = view.invocations[8] else {
			return XCTFail("`load` must be invocked")
		}

		guard case .configurePlaceholder = view.invocations[9] else {
			return XCTFail("`configurePlaceholder` must be invocked")
		}
	}

}

// MARK: - Helpers
extension ThreadDetailScreenPresenterTests {

	typealias CHThreadPayload = CHThreadDetailResponse.CHThreadPayload
	typealias CHPost = CHThreadDetailResponse.CHPost

	func makeThreadDetailResponse() -> CHThreadDetailResponse {
		let posts: [CHPost] = [makePost(num: 0),
							   makePost(num: 1),
							   makePost(num: 2),
							   makePost(num: 3)]
		let payload = CHThreadPayload(posts: posts)
		return .init(filesCount: 20,
					 isClosed: 0,
					 postsCount: 120,
					 threadPayload: [payload])
	}

	func makePost(num: Int) -> CHPost {
		return .init(num: num,
					 parent: 3123123,
					 board: "news",
					 timestamp: 12441414,
					 date: "10-10-23",
					 views: 101,
					 name: "post",
					 comment: "It is my first post")
	}

	func makePayload(boardIdentifier: String, boardName: String, thread: Int) -> ThreadDetailScreen.Payload {
		return .init(boardIdentifier: boardIdentifier,
					 boardName: boardName,
					 thread: thread)
	}
}
