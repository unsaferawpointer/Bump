//
//  ThreadDetailScreen + Interactor.swift
//  Bump
//
//  Created by Anton Cherkasov on 11.03.2023.
//

import Foundation

protocol ThreadDetailScreenInteractorOutput {

	typealias PostModel = ThreadDetailScreen.PostModel

	func reload(_ models: [PostModel])
	func performTransition(to post: Int)
	func startLoading()
	func stopLoading()
}

/// Interface of the ThreadDetailScreen interactor
protocol ThreadDetailScreenInteractor {

	/// Fetch all threads in specific board
	func fetchThreads()

	/// Perform transition to link
	///
	/// - Parameters:
	///    - link: Destionation
	func performTransition(to link: URL)

	/// Cancel task of the fetching
	func cancelFetching()
}

extension ThreadDetailScreen {

	/// ThreadDetailScreen interactor
	final class Interactor {

		// MARK: - DI

		weak var output: ThreadDetailScreenOutput?

		var presenter: ThreadDetailScreenInteractorOutput?

		var payload: ThreadDetailScreen.Payload {
			didSet {
				guard oldValue != payload else {
					return
				}
			}
		}

		var networkService: NetworkServiceProtocol = NetworkService()

		var deeplinkManager: DeeplinkManagerProtocol = DeeplinkManager()

		var textProcessor: TextProcessorProtocol = TextProcessor()

		/// Only for testing
		private (set) var completionsTask: Task<Void, Never>?

		/// Initialization
		///
		/// - Parameters:
		///    - payload: Payload of the posts screen unit
		///    - output: Output of the posts screen unit
		init(payload: ThreadDetailScreen.Payload,
			 output: ThreadDetailScreenOutput? = nil) {
			self.output = output
			self.payload = payload
		}
	}
}

// MARK: - ThreadDetailScreenInteractor
extension ThreadDetailScreen.Interactor: ThreadDetailScreenInteractor {

	func performTransition(to link: URL) {
		process(link: link)
	}

	func fetchThreads() {
		let request = PostsEndpoint(board: payload.board, thread: payload.thread)
		presenter?.startLoading()
		completionsTask = Task {
			do {
				let response = try await networkService.fetchObject(request)
				let models = await prepareModels(response)
				await stopLoading()
				await reload(models)
			} catch {
				await showError(error)
			}
		}
	}

	func cancelFetching() {
		completionsTask?.cancel()
	}
}

// MARK: - Helpers
private extension ThreadDetailScreen.Interactor {

	typealias PostModel = ThreadDetailScreen.PostModel

	@MainActor
	func stopLoading() {
		presenter?.stopLoading()
	}

	@MainActor
	func reload(_ models: [PostModel]) {
		presenter?.reload(models)
	}

	@MainActor
	func showError(_ error: Error) { }

	func prepareModels(_ response: CHThreadDetailResponse) async -> [PostModel] {
		guard let payload = response.threadPayload.first else {
			return []
		}
		let posts = payload.posts
			.sorted { lhs, rhs in
				lhs.num < rhs.num
			}
		var models: [PostModel] = []

		let linkAction = { [weak self] (url: URL) in
			guard let self else {
				return
			}
			self.performTransition(to: url)
		}

		for post in posts {
			let formattedText = await textProcessor.formatted(post.comment)
			let model = PostModel(id: post.num,
								  likes: post.likes ?? 0,
								  dislikes: post.dislikes ?? 0,
								  body: post.comment,
								  formattedBody: formattedText,
								  linkAction: linkAction,
								  date: Date(timeIntervalSince1970: TimeInterval(post.timestamp)))
			models.append(model)
		}
		return models
	}

	func process(link: URL) {

		guard let endpoint = deeplinkManager.makeDeeplinkIfPossible(link) else {
			output?.userTappedOnLink(link)
			return
		}

		guard
			let board = endpoint.board,
			let thread = endpoint.thread,
			isLocal(board: board, thread: thread)
		else {
			output?.performEndpoint(endpoint)
			return
		}

		guard let post = endpoint.post else {
			return
		}
		presenter?.performTransition(to: post)
	}

	func isLocal(board: String, thread: Int) -> Bool {
		return board == payload.board && thread == payload.thread
	}
}
