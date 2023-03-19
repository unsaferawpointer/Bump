//
//  ThreadDetailScreen.swift
//  Bump
//
//  Created by Anton Cherkasov on 11.03.2023.
//

import Foundation

/// Unit of the posts screen
struct ThreadDetailScreen { }

/// Delegate of the posts screen unit
protocol ThreadDetailScreenOutput: AnyObject {

	/// User tapped on link in the post cell
	///
	/// - Parameters:
	///    - link: Link in the post text
	func userTappedOnLink(_ link: URL)

	/// Perform transition to endpoint
	///
	/// - Parameters:
	///    - endpoint: Destination
	func performEndpoint(_ endpoint: DeeplinkEndpoint)
}

// MARK: - Nested data structs
extension ThreadDetailScreen {

	/// Payload of the unit
	struct Payload: Equatable{

		var board: String

		var thread: Int
	}
}
