//
//  ThreadDetailScreen + CellModel.swift
//  Bump
//
//  Created by Anton Cherkasov on 11.03.2023.
//

import Foundation

extension ThreadDetailScreen {

	/// ViewModel of the post cell
	struct CellModel: Hashable {

		/// Post number
		var id: Int

		/// Counts of the likes
		var likes: Int

		/// Counts of the dislikes
		var dislikes: Int

		/// Comment of the post
		var body: String

		/// Post creation date
		var date: Date

	}
}
