//
//  ThreadDetailScreen + Interactor.swift
//  Bump
//
//  Created by Anton Cherkasov on 11.03.2023.
//

/// Interface of the ThreadDetailScreen interactor
protocol ThreadDetailScreenInteractor {

	/// Fetch all threads in specific board
	func fetchThreads(for board: String, thread: Int) async -> Result<CHThreadDetailResponse, Error>
}

extension ThreadDetailScreen {

	/// ThreadDetailScreen interactor
	final class Interactor {

		// MARK: - DI

		var networkService: NetworkServiceProtocol = NetworkService()
	}
}

// MARK: - ThreadDetailScreenInteractor
extension ThreadDetailScreen.Interactor: ThreadDetailScreenInteractor {

	func fetchThreads(for board: String, thread: Int) async -> Result<CHThreadDetailResponse, Error> {
		do {
			let request = PostsEndpoint(board: board, thread: thread)
			let response = try await networkService.fetchObject(request)
			return .success(response)
		} catch {
			return .failure(error)
		}
	}
}
