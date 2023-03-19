//
//  ThreadDetailScreen + InteractorTests.swift
//  BumpTests
//
//  Created by Anton Cherkasov on 28.03.2023.
//

import XCTest
@testable import Bump

final class ThreadDetailScreenInteractorTests: XCTestCase {

	private var sut: ThreadDetailScreen.Interactor!

	private var presenter: ThreadDetailScreenInteractorOutputMock!

	private var deeplinkManager: DeeplinkManagerStub!

	private var output: ThreadDetailScreenOutputSpy!

	private var networkService: NetworkServiceMock!

	override func setUpWithError() throws {
		presenter = ThreadDetailScreenInteractorOutputMock()
		deeplinkManager = DeeplinkManagerStub()
		output = ThreadDetailScreenOutputSpy()
		networkService = NetworkServiceMock()
		sut = ThreadDetailScreen.Interactor(payload: .init(board: "news", thread: 1234567))
		sut.presenter = presenter
		sut.deeplinkManager = deeplinkManager
		sut.output = output
		sut.networkService = networkService
	}

	override func tearDownWithError() throws {
		sut = nil
		presenter = nil
		deeplinkManager = nil
		output = nil
		networkService = nil
	}

}

// MARK: - ThreadDetailScreenInteractor cases
extension ThreadDetailScreenInteractorTests {

	func testPerformTransitionWhenTransitionIsLocal() throws {
		// Arrange
		let url = try XCTUnwrap(URL(string: "deeplink://thread/1234567/1234567"))
		deeplinkManager.stub = .thread(board: "news", thread: 1234567)

		// Act
		sut.performTransition(to: url)

		// Assert
		guard case let .performTransition(post) = presenter.invocations[0] else {
			return XCTFail("`performTransition` must be invocked")
		}
		XCTAssertEqual(post, 1234567)
	}

	func testPerformTransitionWhenTransitionIsExternal() throws {
		// Arrange
		let url = try XCTUnwrap(URL(string: "https://fakehost.com/path"))
		deeplinkManager.stub = nil

		// Act
		sut.performTransition(to: url)

		// Assert
		guard case let .userTappedOnLink(link) = output.invocations[0] else {
			return XCTFail("`performTransition` must be invocked")
		}
		XCTAssertEqual(link, url)
	}

	func testPerformTransitionWhenTransitionIsEndpoint() throws {
		// Arrange
		let url = try XCTUnwrap(URL(string: "https://fakehost.com/path"))
		deeplinkManager.stub = .post(board: "news", thread: 2345678, post: 7654321)

		// Act
		sut.performTransition(to: url)

		// Assert
		guard case let .performEndpoint(endpoint) = output.invocations[0] else {
			return XCTFail("`performEndpoint` must be invocked")
		}
		XCTAssertEqual(endpoint, .post(board: "news", thread: 2345678, post: 7654321))
	}

	func testFetchThreads() async {
		// Arrange
		networkService.addStub(for: PostsEndpoint.self, response: makeThreadDetailResponse())

		// Act
		sut.fetchThreads()

		// Assert
		guard case .startLoading = presenter.invocations[0] else {
			return XCTFail("`startLoading` must be invocked")
		}
		_ = await sut.completionsTask?.result

		guard case .stopLoading = presenter.invocations[1] else {
			return XCTFail("`stopLoading` must be invocked")
		}

		guard case let .reload(models) = presenter.invocations[2] else {
			return XCTFail("`reload` must be invocked")
		}

		XCTAssertEqual(models.count, 4)
	}

	func cancelFetching() throws {
		// Act
		sut.cancelFetching()

		// Assert
		let task = try XCTUnwrap(sut.completionsTask)
		XCTAssertTrue(task.isCancelled)
	}
}

// MARK: - Helpers
extension ThreadDetailScreenInteractorTests {

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

	func makePayload(boardIdentifier: String, thread: Int) -> ThreadDetailScreen.Payload {
		return .init(board: boardIdentifier, thread: thread)
	}

	struct FakeRequest: Request {

		typealias Response = CHThreadDetailResponse

		var path: String = "fakePath"

		var httpMethod: String = "POST"
	}
}
