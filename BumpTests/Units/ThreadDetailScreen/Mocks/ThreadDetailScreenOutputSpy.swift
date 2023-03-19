//
//  ThreadDetailScreenOutputSpy.swift
//  BumpTests
//
//  Created by Anton Cherkasov on 28.03.2023.
//

import Foundation
@testable import Bump

final class ThreadDetailScreenOutputSpy {

	var invocations: [Action] = []
}

// MARK: - ThreadDetailScreenOutput
extension ThreadDetailScreenOutputSpy: ThreadDetailScreenOutput {

	func userTappedOnLink(_ link: URL) {
		invocations.append(.userTappedOnLink(link))
	}

	func performEndpoint(_ endpoint: DeeplinkEndpoint) {
		invocations.append(.performEndpoint(endpoint))
	}

}

// MARK: - Nested data structs
extension ThreadDetailScreenOutputSpy {

	enum Action {
		case userTappedOnLink(_ link: URL)
		case performEndpoint(_ endpoint: DeeplinkEndpoint)
	}
}
