//
//  ThreadsScreenInteractorMock.swift
//  BumpTests
//
//  Created by Anton Cherkasov on 26.02.2023.
//

@testable import Bump

final class ThreadsScreenInteractorMock {

	var threadsResponseStub: CHThreadsResponse? = nil

	var error: Error?
}

// MARK: - ThreadsScreenInteractor
extension ThreadsScreenInteractorMock: ThreadsScreenInteractor {

	func fetchThreads(for board: String) async -> Result<CHThreadsResponse, Error> {
		guard let error else {
			guard let response = threadsResponseStub else {
				fatalError("Please, setup response stub")
			}
			return .success(response)
		}
		return .failure(error)
	}
}
