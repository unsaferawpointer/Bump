//
//  CHThreadDetailResponse.swift
//  Bump
//
//  Created by Anton Cherkasov on 10.01.2023.
//

/// Model of the thread detail
struct CHThreadDetailResponse: Codable {

	var filesCount: Int
	var isClosed: Int
	var postsCount: Int
	var threadPayload: [CHThreadPayload]
}

// MARK: - CodingKey
extension CHThreadDetailResponse {

	enum CodingKeys: String, CodingKey {
		case filesCount = "files_count"
		case isClosed = "is_closed"
		case postsCount = "posts_count"
		case threadPayload = "threads"
	}
}

// MARK: - Nested data structs
extension CHThreadDetailResponse {

	/// Model of the post response
	struct CHPost: Codable {
		var num: Int
		var parent: Int
		var board: String
		var timestamp: Int
		var date: String
		var email: String?
		var subject: String?
		var views: Int
		var name: String
		var comment: String
		var likes: Int?
		var dislikes: Int?
		var files: [CHFile]?
	}

	struct CHFile: Codable {
		var name: String
		var fullname: String
		var displayname: String
		var path: String
		var thumbnail: String
		var type: CHFileType
		var height: Int
		var width: Int
		var size: Int
	}

	/// Model of the thread payload
	struct CHThreadPayload: Codable {

		var posts: [CHPost]
	}

}

// MARK: - Identifiable
extension CHThreadDetailResponse.CHFile: Identifiable {

	var id: String {
		return path
	}
}
