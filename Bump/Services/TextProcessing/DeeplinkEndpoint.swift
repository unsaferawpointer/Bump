//
//  DeeplinkEndpoint.swift
//  Please bump
//
//  Created by Anton Cherkasov on 22.01.2023.
//

import Foundation

enum DeeplinkEndpoint {

	/// Go to specific post
	case post(board: String, thread: Int, post: Int)

	/// Go to specific thread
	case thread(board: String, thread: Int)

	init?(url: URL) {

		let pathComponents = url.pathComponents.filter { $0 != "/" }

		guard
			let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true),
			components.scheme == DeeplinkEndpoint.scheme, let board = pathComponents.first

		else {
			return nil
		}

		guard let thread = Int(pathComponents[1]) else {
			return nil
		}

		switch components.host {
			case "post":
				guard let post = Int(pathComponents[2]) else {
					return nil
				}
				self = .post(board: board, thread: thread, post: post)
				return
			case "thread":
				self = .thread(board: board, thread: thread)
				return
			default: break
		}
		return nil
	}

}

// MARK: - Hashable
extension DeeplinkEndpoint: Hashable { }

// MARK: - Calculated properties
extension DeeplinkEndpoint {

	/// Scheme of the deeplink
	static var scheme: String {
		return "bump"
	}

	var board: String? {
		switch self {
			case .post(let board, _, _):	return board
			case .thread(let board, _):		return board
		}
	}

	var thread: Int? {
		switch self {
			case .post( _, let thread, _):	return thread
			case .thread( _, let thread):	return thread
		}
	}

	var post: Int? {
		switch self {
			case .post( _, _, let post):	return post
			case .thread( _, let thread):	return thread
		}
	}

	var host: String {
		switch self {
			case .post:		return "post"
			case .thread:	return "thread"
		}
	}

	var path: String {
		switch self {
			case .post(let board, let thread, let post):
				return "/\(board)" + "/\(thread)" + "/\(post)"
			case .thread(let board, let thread):
				return "/\(board)" + "/\(thread)"
		}
	}

	var url: URL? {

		let components = NSURLComponents()
		components.scheme = "deeplink"
		components.host = host
		components.path = path

		return components.url
	}
}
