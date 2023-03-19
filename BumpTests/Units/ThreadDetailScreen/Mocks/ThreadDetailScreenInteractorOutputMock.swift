//
//  ThreadDetailScreenInteractorOutputMock.swift
//  BumpTests
//
//  Created by Anton Cherkasov on 28.03.2023.
//

import Foundation
@testable import Bump

final class ThreadDetailScreenInteractorOutputMock {
	var invocations: [Action] = []
}

// MARK: - ThreadDetailScreenInteractorOutput
extension ThreadDetailScreenInteractorOutputMock: ThreadDetailScreenInteractorOutput {

	func reload(_ models: [PostModel]) {
		invocations.append(.reload(models))
	}

	func performTransition(to post: Int) {
		invocations.append(.performTransition(post: post))
	}

	func startLoading() {
		invocations.append(.startLoading)
	}

	func stopLoading() {
		invocations.append(.stopLoading)
	}
}

// MARK: - Nested data structs
extension ThreadDetailScreenInteractorOutputMock {

	enum Action {
		case reload(_ models: [PostModel])
		case performTransition(post: Int)
		case startLoading
		case stopLoading
	}
}
