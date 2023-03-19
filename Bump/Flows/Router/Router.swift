//
//  Routable.swift
//  Bump
//
//  Created by Anton Cherkasov on 04.03.2023.
//

import UIKit

/// Application router
final class Router: NSObject {

	private (set) var navigationController: UINavigationController

	private var closures: [AnyHashable: (AnyHashable) -> Void] = [:]

	/// Initialization
	///
	/// - Parameters:
	///    - navigationController: Navigation controller of the flow
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
}

// MARK: - Routable
extension Router: Routable {

	func push(_ viewRepresentable: ViewRepresentable, animated: Bool, onBack: @escaping (AnyHashable) -> Void) {
		closures[viewRepresentable.id] = onBack
		navigationController.pushViewController(viewRepresentable.toPresent, animated: animated)
	}

	func pop(animated: Bool) {
		guard
			let viewController = navigationController.popViewController(animated: animated)
		else {
			return
		}
		let action = closures.removeValue(forKey: viewController.id)
		action?(viewController.id)
	}

	func start(root: ViewRepresentable, animated: Bool, onBack: @escaping (AnyHashable) -> Void) {
		navigationController.pushViewController(root.toPresent, animated: animated)
		closures[root.id] = onBack
		navigationController.delegate = self
	}

	func openURL(_ url: URL) {
		UIApplication.shared.open(url, options: [:]) { _ in }
	}

	func showAlert(on viewRepresentable: ViewRepresentable, title: String, message: String) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		viewRepresentable.toPresent.present(alert, animated: true)
	}
}

// MARK: - UINavigationControllerDelegate
extension Router: UINavigationControllerDelegate {

	func navigationController(_ navigationController: UINavigationController,
							  didShow viewController: UIViewController,
							  animated: Bool) {
		let transitionCoordinator = navigationController.transitionCoordinator
		guard let source = transitionCoordinator?.viewController(forKey: .from) as? ViewRepresentable else {
			return
		}
		let action = closures.removeValue(forKey: source.id)
		action?(source.id)
	}
}
