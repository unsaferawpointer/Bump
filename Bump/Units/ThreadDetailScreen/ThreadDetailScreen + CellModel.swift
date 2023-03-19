//
//  ThreadDetailScreen + PostModel.swift
//  Bump
//
//  Created by Anton Cherkasov on 11.03.2023.
//

import Foundation

extension ThreadDetailScreen {

	/// ViewModel of the post cell
	struct PostModel {

		/// Post number
		var id: Int

		/// Counts of the likes
		var likes: Int

		/// Counts of the dislikes
		var dislikes: Int

		/// Comment of the post in html - format
		var body: String

		var formattedBody: NSAttributedString

		var linkAction: (URL) -> Void

		/// Post creation date
		var date: Date

	}
}

// MARK: - Hashable
extension ThreadDetailScreen.PostModel: Hashable {

	static func == (lhs: ThreadDetailScreen.PostModel, rhs: ThreadDetailScreen.PostModel) -> Bool {
		return lhs.id == rhs.id
	}

	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
}
