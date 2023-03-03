//
//  ThreadsScreen + CellConfiguration.swift
//  Bump
//
//  Created by Anton Cherkasov on 25.02.2023.
//

import UIKit

extension ThreadsScreen {

	/// Thread cell configuration
	struct CellConfiguration: UIContentConfiguration, Hashable {

		var title: String = ""

		var viewsCount: Int = 0

		var repliesCount: Int = 0

		func makeContentView() -> UIView & UIContentView {
			return Cell(self)
		}

		func updated(for state: UIConfigurationState) -> ThreadsScreen.CellConfiguration {
			// Perform update on parameters that does not related to cell's data itesm

			// Make sure we are dealing with instance of UICellConfigurationState
			guard let _ = state as? UICellConfigurationState else {
				return self
			}

			// Updater self based on the current state
			let updatedConfiguration = self
			return updatedConfiguration
		}
	}
}
