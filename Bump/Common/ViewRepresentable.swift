//
//  ViewRepresentable.swift
//  Bump
//
//  Created by Anton Cherkasov on 26.03.2023.
//

import UIKit

/// Ability to be present as ViewController
protocol ViewRepresentable {

	/// Identifier
	var id: AnyHashable { get }

	/// View controller
	var toPresent: UIViewController { get }

}

// MARK: - ViewRepresentable
extension UIViewController: ViewRepresentable {

	var id: AnyHashable {
		return ObjectIdentifier(self)
	}

	var toPresent: UIViewController {
		return self
	}
}
