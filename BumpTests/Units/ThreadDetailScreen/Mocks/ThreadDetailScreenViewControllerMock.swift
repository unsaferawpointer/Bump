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

	typealias Snapshot = NSDiffableDataSourceSnapshot<String, ThreadDetailScreen.CellModel>

	func startProgressAnimation() {
		invocations.append(.startProgressAnimation)
	}

	func stopProgressAnimation() {
		invocations.append(.stopProgressAnimation)
	}

	func configure(title: String) {
		invocations.append(.configure(title: title))
	}

	func load(_ snapshot: NSDiffableDataSourceSnapshot<String, ThreadDetailScreen.CellModel>) {
		invocations.append(.load(snapshot))
	}

	func configurePlaceholder(model: ZeroViewModel?) {
		invocations.append(.configurePlaceholder(model))
	}

}

// MARK: - Nested data structs
extension ThreadDetailScreenViewControllerMock {

	enum Action {
		case startProgressAnimation
		case stopProgressAnimation
		case configure(title: String)
		case load(_ snapshot: Snapshot)
		case configurePlaceholder(_ model: ZeroViewModel?)
	}
}
