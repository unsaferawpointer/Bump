//
//  ThreadsScreen + CellModell.swift
//  Bump
//
//  Created by Anton Cherkasov on 24.02.2023.
//

extension ThreadsScreen {

	/// ViewModel of the thread cell
	struct CellModel: Hashable {

		var id: Int

		var title: String

		var replies: Int
		var views: Int
	}
}
