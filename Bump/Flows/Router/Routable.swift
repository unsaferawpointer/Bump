//
//  Routable.swift
//  Bump
//
//  Created by Anton Cherkasov on 27.03.2023.
//

import UIKit

/// Interface of the router
protocol Routable {

	/// Push viewcontroller to primary navigation stack
	///
	/// - Parameters:
	///    - viewRepresentable: View to pushing to navigation stack
	///    - animated: Animate transition
	///    - onBack: Completion handler of the forward navigation
	func push(_ viewRepresentable: ViewRepresentable,
			  animated: Bool,
			  onBack: @escaping (AnyHashable) -> Void)

	/// Pop viewcontroller in navigation stack
	///
	/// - Parameters:
	///    - animated: Animate transition
	func pop(animated: Bool)

	/// Open url
	///
	/// - Parameters:
	///    - url: URL
	func openURL(_ url: URL)

	/// Make window visible
	///
	/// - Parameters:
	///    - root: Navigation root viewcontroller
	///    - animated: Animate transition
	///    - onBack: Completion handler of the forward navigation
	func start(root: ViewRepresentable, animated: Bool, onBack: @escaping (AnyHashable) -> Void)

	func showAlert(on viewRepresentable: ViewRepresentable, title: String, message: String)

}
