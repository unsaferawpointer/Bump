//
//  ThreadsScreenViewControllerMock.swift
//  BumpTests
//
//  Created by Anton Cherkasov on 26.02.2023.
//

import UIKit
@testable import Bump

final class ThreadsScreenViewControllerMock {

	var invocations: [Action] = []

}

// MARK: - ThreadsScreenViewController
extension ThreadsScreenViewControllerMock: ThreadsScreenViewController {

	typealias Snapshot = NSDiffableDataSourceSnapshot<String, ThreadsScreen.CellModel>

	func startProgressAnimation() {
		invocations.append(.startProgressAnimation)
	}

	func stopProgressAnimation() {
		invocations.append(.stopProgressAnimation)
	}

	func configure(title: String) {
		invocations.append(.configure(title: title))
	}

	func load(_ snapshot: NSDiffableDataSourceSnapshot<String, ThreadsScreen.CellModel>) {
		invocations.append(.load(snapshot))
	}

	func configurePlaceholder(model: ZeroViewModel?) {
		invocations.append(.configurePlaceholder(model))
	}

}

// MARK: - Nested data structs
extension ThreadsScreenViewControllerMock {

	enum Action {
		case startProgressAnimation
		case stopProgressAnimation
		case configure(title: String)
		case load(_ snapshot: Snapshot)
		case configurePlaceholder(_ model: ZeroViewModel?)
	}
}
