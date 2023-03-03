//
//  ThreadsScreen + Interactor.swift
//  Bump
//
//  Created by Anton Cherkasov on 24.02.2023.
//

/// Interface of the ThreadsScreen interactor
protocol ThreadsScreenInteractor {

	/// Fetch all threads in specific board
	func fetchThreads(for board: String) async -> Result<CHThreadsResponse, Error>
}

extension ThreadsScreen {

	/// ThreadsScreen interactor
	final class Interactor {

		// MARK: - DI

		var networkService: NetworkServiceProtocol = NetworkService()
	}
}

// MARK: - ThreadsScreenInteractor
extension ThreadsScreen.Interactor: ThreadsScreenInteractor {

	func fetchThreads(for board: String) async -> Result<CHThreadsResponse, Error> {
		do {
			let response = try await networkService.fetchObject(ThreadsEndpoint(board: board))
			return .success(response)
		} catch {
			return .failure(error)
		}
	}
}
