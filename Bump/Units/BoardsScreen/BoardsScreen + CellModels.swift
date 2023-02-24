//
//  BoardsScreen + CellModels.swift
//  Bump
//
//  Created by Anton Cherkasov on 21.02.2023.
//

extension BoardsScreen {

	/// ViewModel of header cell
	struct HeaderModel: Hashable {

		let title: String
	}
}

extension BoardsScreen {

	/// ViewModel of board cell
	struct CellModel: Hashable {

		let id: String

		let title: String
		let subtitle: String
		let detail: String
	}
}
