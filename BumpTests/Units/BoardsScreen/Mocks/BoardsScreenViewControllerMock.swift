//
//  File.swift
//  BumpTests
//
//  Created by Anton Cherkasov on 23.02.2023.
//

import UIKit
@testable import Bump

final class BoardsScreenViewControllerMock {

	var invocations: [Action] = []

}

// MARK: - BoardsScreenViewController
extension BoardsScreenViewControllerMock: BoardsScreenViewController {

	typealias Snapshot = NSDiffableDataSourceSnapshot<BoardsScreen.HeaderModel, BoardsScreen.CellModel>

	func startProgressAnimation() {
		invocations.append(.startProgressAnimation)
	}

	func stopProgressAnimation() {
		invocations.append(.stopProgressAnimation)
	}

	func configure(title: String) {
		invocations.append(.configure(title: title))
	}

	func load(_ snapshot: NSDiffableDataSourceSnapshot<Bump.BoardsScreen.HeaderModel, Bump.BoardsScreen.CellModel>) {
		invocations.append(.load(snapshot))
	}
}

// MARK: - Nested data structs
extension BoardsScreenViewControllerMock {

	enum Action {
		case startProgressAnimation
		case stopProgressAnimation
		case configure(title: String)
		case load(_ snapshot: Snapshot)
	}
}
