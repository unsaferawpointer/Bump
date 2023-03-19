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

	override func setUpWithError() throws {

		sut = ThreadDetailScreen.Presenter()

		interactor = ThreadDetailScreenInteractorMock()
		sut.interactor = interactor

		view = ThreadDetailScreenViewControllerMock()
		sut.view = view

	}

	override func tearDownWithError() throws {
		sut = nil
		view = nil
		interactor = nil
	}
}

// MARK: - ThreadDetailScreenViewOutput cases
extension ThreadDetailScreenPresenterTests {

	func testViewControllerDidChangeStateWhenStateIsDidLoad() {
		// Arrange
		sut.title = UUID().uuidString

		// Act
		sut.viewController(didChangeState: .didLoad)

		// Assert
		guard case .fetchThreads = interactor.invocations[0] else {
			return XCTFail("`fetchThreads` must be invocked")
		}

		guard case let .configureTitle(title) = view.invocations[0] else {
			return XCTFail("`configureTitle` must be invocked")
		}
		XCTAssertEqual(title, sut.title)
	}

	func testViewControllerDidChangeStateWhenStateIsDidDisappear() {
		// Act
		sut.viewController(didChangeState: .didDisappear)

		// Assert
		guard case .cancelFetching = interactor.invocations[0] else {
			return XCTFail("`cancelFetching` must be invocked")
		}
	}

	func testViewControllerRefreshData() {
		// Act
		sut.refreshData()

		// Assert
		guard case .fetchThreads = interactor.invocations[0] else {
			return XCTFail("`fetchThreads` must be invocked")
		}
	}
}

// MARK: - ThreadDetailScreenInteractorOutput test-cases
extension ThreadDetailScreenPresenterTests {

	func testReload() async {
		// Arrange
		let models = makeModels()

		// Act
		sut.reload(models)

		// Assert
		guard case .stopProgressAnimation = view.invocations[0] else {
			return XCTFail("`stopProgressAnimation` must be invocked")
		}

		guard case let.configureSnapshot(snapshot) = view.invocations[1] else {
			return XCTFail("`stopProgressAnimation` must be invocked")
		}

		XCTAssertEqual(snapshot.numberOfItems, 4)
		XCTAssertEqual(snapshot.numberOfSections, 1)
		XCTAssertEqual(view.invocations.count, 2)
	}

	func testPerformTransition(to post: Int) {
		// Act
		sut.performTransition(to: 0)

		// Assert
		guard case let .scrollTo(postNumber) = view.invocations[0] else {
			return XCTFail("`scrollTo` must be invocked")
		}
		XCTAssertEqual(postNumber, 0)
	}

	func testStartLoading() {
		// Act
		sut.startLoading()

		// Assert
		guard case .startProgressAnimation = view.invocations[0] else {
			return XCTFail("`startProgressAnimation` must be invocked")
		}
	}

	func testStopLoading() {
		// Act
		sut.stopLoading()

		// Assert
		guard case .stopProgressAnimation = view.invocations[0] else {
			return XCTFail("`stopProgressAnimation` must be invocked")
		}
	}
}

// MARK: - Helpers
extension ThreadDetailScreenPresenterTests {

	typealias PostModel = ThreadDetailScreen.PostModel

	func makeModels() -> [PostModel] {
		return (0...3).map { makePostModel(id: $0) }
	}

	func makePostModel(id: Int) -> PostModel {
		let body = UUID().uuidString
		return PostModel(id: id,
						 likes: 0,
						 dislikes: 0,
						 body: body,
						 formattedBody: .init(string: body),
						 linkAction: { _ in },
						 date: .now)
	}
}
