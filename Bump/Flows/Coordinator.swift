//
//  Coordinator.swift
//  Bump
//
//  Created by Anton Cherkasov on 27.03.2023.
//

import Foundation

protocol CoordinatorOutput: AnyObject {
	func flowHasBeenFinished()
}

/// Main coordinator of the application
final class Coordinator {

	private var router: Routable

	weak var output: CoordinatorOutput?

	/// Base initialization
	///
	/// - Parameters:
	///    - router: Router of the current flow
	init(router: Routable) {
		self.router = router
	}
}

// MARK: - Coordinatable
extension Coordinator: Coordinatable {

	func start() {
		let screen = BoardsScreen.makeScreen(output: self)
		router.start(root: screen, animated: false, onBack: { [weak output] _ in
			output?.flowHasBeenFinished()
		})
	}
}

// MARK: - BoardsScreenOutput
extension Coordinator: BoardsScreenOutput {

	func unitInvockedAction(_ action: BoardsScreen.Action) {
		guard case let .userSelectedBoard(board) = action else {
			return
		}
		let screen = ThreadsScreen.makeScreen(board: board, output: self)
		router.push(screen, animated: true, onBack: { _ in })
	}
}

// MARK: - ThreadsScreenOutput
extension Coordinator: ThreadsScreenOutput {

	func unitInvockedAction(_ action: ThreadsScreen.Action) {
		guard case let .userSelectedThread(board, thread) = action else {
			return
		}
		let payload = ThreadDetailScreen.Payload(board: board, thread: thread)
		let screen = ThreadDetailScreen.Assembly().makeMainScreen(payload, output: self)
		router.push(screen, animated: true, onBack: { _ in })
	}
}

// MARK: - ThreadDetailScreenOutput
extension Coordinator: ThreadDetailScreenOutput {

	func userTappedOnLink(_ link: URL) {
		router.openURL(link)
	}

	func performEndpoint(_ endpoint: DeeplinkEndpoint) {
		let payload: ThreadDetailScreen.Payload?

		switch endpoint {
			case .post(let board, let thread, _):
				payload = ThreadDetailScreen.Payload(board: board, thread: thread)
			case .thread(let board, let thread):
				payload = ThreadDetailScreen.Payload(board: board, thread: thread)
		}

		guard let payload else {
			return
		}

		let screen = ThreadDetailScreen.Assembly().makeMainScreen(payload, output: self)
		router.push(screen, animated: true, onBack: { _ in })
	}
}
