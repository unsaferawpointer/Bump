//
//  BoardsScreenInteractorMock.swift
//  BumpTests
//
//  Created by Anton Cherkasov on 23.02.2023.
//

@testable import Bump

final class BoardsScreenInteractorMock {

	var boardsStub: [CHBoard] = []

	var error: Error?
}

// MARK: - BoardsScreenInteractor
extension BoardsScreenInteractorMock: BoardsScreenInteractor {

	func fetchBoards() async throws -> [CHBoard] {
		guard let error else {
			return boardsStub
		}
		throw error
	}
}
