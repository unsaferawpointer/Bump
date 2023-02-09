//
//  CHThreadsResponse.swift
//  Bump
//
//  Created by Anton Cherkasov on 10.01.2023.
//

/// Response model of the ThreadsEnpoint
struct CHThreadsResponse: Codable {
	var threads: [CHThread]
}

// MARK: - Nested data structs
extension CHThreadsResponse {

	/// Model of the thread
	struct CHThread: Codable {

		// MARK: - Required
		var num: Int
		var board: String

		// MARK: - Optional
		var name: String?
		var timestamp: Int
		var email: String?
		var banned: Int?
		var subject: String?
		var comment: String?
		var postsCount: Int?
		var views: Int?
		var likes: Int?
		var files: [CHFile]?
	}

	/// Model of the file
	struct CHFile: Codable {

		// MARK: - Required
		var displayname: String
		var fullname: String
		var path: String
		var thumbnail: String
	}

}

// MARK: - CodingKey
extension CHThreadsResponse.CHThread {

	enum CodingKeys: String, CodingKey {
		case num
		case board
		case name
		case timestamp
		case email
		case banned
		case subject
		case comment
		case postsCount = "posts_count"
		case views
		case likes
		case files
	}
}
