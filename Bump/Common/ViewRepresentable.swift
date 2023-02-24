//
//  ViewRepresentable.swift
//  Bump
//
//  Created by Anton Cherkasov on 24.02.2023.
//

import UIKit

/// Ability to be present as UIViewController
protocol ViewRepresentable {
	func toPresent() -> UIViewController
}
