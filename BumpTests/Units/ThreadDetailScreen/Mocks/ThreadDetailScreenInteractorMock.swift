//
//  ThreadDetailScreenInteractorMock.swift
//  BumpTests
//
//  Created by Anton Cherkasov on 26.02.2023.
//

@testable import Bump

final class ThreadDetailScreenInteractorMock {

	var threadDetailResponseStub: CHThreadDetailResponse? = nil

	var error: Error?
}

// MARK: - ThreadDetailScreenInteractor
extension ThreadDetailScreenInteractorMock: ThreadDetailScreenInteractor {

	func fetchThreads(for board: String, thread: Int) async -> Result<CHThreadDetailResponse, Error> {
		guard let error else {
			guard let response = threadDetailResponseStub else {
				fatalError("Please, setup response stub")
			}
			return .success(response)
		}
		return .failure(error)
	}
}
