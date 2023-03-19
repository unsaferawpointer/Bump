//
//  ThreadDetailScreenViewControllerMock.swift
//  BumpTests
//
//  Created by Anton Cherkasov on 26.02.2023.
//

import UIKit
@testable import Bump

final class ThreadDetailScreenViewControllerMock {

	var invocations: [Action] = []

}

// MARK: - ThreadDetailScreenViewController
extension ThreadDetailScreenViewControllerMock: ThreadDetailScreenViewController {

	func startProgressAnimation() {
		invocations.append(.startProgressAnimation)
	}

	func stopProgressAnimation() {
		invocations.append(.stopProgressAnimation)
	}

	func configure(title: String) {
		invocations.append(.configureTitle(title))
	}

	func configure(snapshot: Snapshot) {
		invocations.append(.configureSnapshot(snapshot))
	}

	func scrollTo(postNumber: Int) {
		invocations.append(.scrollTo(postNumber: postNumber))
	}
}

// MARK: - Nested data structs
extension ThreadDetailScreenViewControllerMock {

	enum Action {
		case startProgressAnimation
		case stopProgressAnimation
		case configureTitle(_ title: String)
		case configureSnapshot(_ snapshot: Snapshot)
		case scrollTo(postNumber: Int)
	}
}
