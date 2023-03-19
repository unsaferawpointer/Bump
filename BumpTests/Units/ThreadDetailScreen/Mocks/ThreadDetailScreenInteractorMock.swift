//
//  ThreadDetailScreenInteractorMock.swift
//  BumpTests
//
//  Created by Anton Cherkasov on 26.02.2023.
//

import Foundation
@testable import Bump

final class ThreadDetailScreenInteractorMock {

	var invocations: [Action] = []

}

// MARK: - ThreadDetailScreenInteractor
extension ThreadDetailScreenInteractorMock: ThreadDetailScreenInteractor {

	func fetchThreads() {
		invocations.append(.fetchThreads)
	}

	func performTransition(to link: URL) {
		invocations.append(.performTransition(link: link))
	}

	func cancelFetching() {
		invocations.append(.cancelFetching)
	}

}

// MARK: - Nested data structs
extension ThreadDetailScreenInteractorMock {

	enum Action {
		case fetchThreads
		case performTransition(link: URL)
		case cancelFetching
	}
}
