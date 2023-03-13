//
//  ThreadDetailScreen + CellConfiguration.swift
//  Bump
//
//  Created by Anton Cherkasov on 11.03.2023.
//

import UIKit

extension ThreadDetailScreen {

	/// Post cell configuration
	struct CellConfiguration: Hashable {

		var number: Int = 0

		var body: String = ""

		var likes: Int = 0

		var dislikes: Int = 0

		var date: Date = .init()
	}
}

// MARK: - UIContentConfiguration
extension ThreadDetailScreen.CellConfiguration: UIContentConfiguration {

	func makeContentView() -> UIView & UIContentView {
		return ThreadDetailScreen.Cell(self)
	}

	func updated(for state: UIConfigurationState) -> ThreadDetailScreen.CellConfiguration {
		// Make sure we are dealing with instance of UICellConfigurationState
		guard let _ = state as? UICellConfigurationState else {
			return self
		}

		// Updater self based on the current state
		let updatedConfiguration = self
		return updatedConfiguration
	}
}
