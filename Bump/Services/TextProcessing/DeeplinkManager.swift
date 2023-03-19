//
//  DeeplinkManager.swift
//  Please bump
//
//  Created by Anton Cherkasov on 22.01.2023.
//

import Foundation

/// Interface of the deeplink manager
protocol DeeplinkManagerProtocol {

	/// Make deeplink from the link
	func makeDeeplinkIfPossible(_ url: URL) -> DeeplinkEndpoint?
}

/// Deeplink manager
final class DeeplinkManager {

	private (set) var scheme: String

	/// Initialization
	///
	/// - Parameters:
	///    - scheme: Scheme of deeplinks
	init(scheme: String = DeeplinkEndpoint.scheme) {
		self.scheme = scheme
	}
}

// MARK: - DeeplinkManagerProtocol
extension DeeplinkManager: DeeplinkManagerProtocol {

	/// Convert link in the text of the post to deeplink if it is possible
	func makeDeeplinkIfPossible(_ url: URL) -> DeeplinkEndpoint? {

		let pathComponents = url.deletingPathExtension().pathComponents.filter { $0 != "/" }

		guard
			let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true),
			components.scheme == "applewebdata", let board = pathComponents.first
		else {
			return nil
		}

		components.scheme = "bump"
		components.host = nil

		guard
			let postString = components.fragment,
			let post = Int(postString),
			let threadString = pathComponents.last,
			let thread = Int(threadString)
		else {
			return nil
		}

		return (post == thread)
					? .thread(board: board, thread: thread)
					: .post(board: board, thread: thread, post: post)

	}
}
