//
//  BoardsScreen + Interactor.swift
//  Bump
//
//  Created by Anton Cherkasov on 23.02.2023.
//

/// Interface of the BoardsScreen interactor
protocol BoardsScreenInteractor {

	/// Fetch all boards
	func fetchBoards() async throws -> [CHBoard]
}

extension BoardsScreen {

	/// BoardsScreen interactor
	final class Interactor {

		// MARK: - DI

		var networkService: NetworkServiceProtocol = NetworkService()
	}
}

// MARK: - BoardsScreenInteractor
extension BoardsScreen.Interactor: BoardsScreenInteractor {

	func fetchBoards() async throws -> [CHBoard] {
		return try await networkService.fetchObject(BoardsEndpoint())
	}
}
