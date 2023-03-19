//
//  RouterSpy.swift
//  BumpTests
//
//  Created by Anton Cherkasov on 19.03.2023.
//

import UIKit
@testable import Bump

final class RouterSpy {

	var invocations: [Action] = []

	var onBack: ((AnyHashable) -> Void)?
}

// MARK: - Routable
extension RouterSpy: Routable {

	func push(_ viewRepresentable: ViewRepresentable, animated: Bool, onBack: @escaping (AnyHashable) -> Void) {
		self.onBack = onBack
		let action: Action = .push(viewRepresentable, animated: animated)
		invocations.append(action)
	}

	func pop(animated: Bool) {
		let action: Action = .pop(animated: animated)
		invocations.append(action)
	}

	func start(root: ViewRepresentable, animated: Bool, onBack: @escaping (AnyHashable) -> Void) {
		let action: Action = .start(root: root, animated: animated)
		invocations.append(action)
		self.onBack = onBack
	}

	func openURL(_ url: URL) {
		let action: Action = .openURL(url)
		invocations.append(action)
	}

	func showAlert(on viewRepresentable: Bump.ViewRepresentable, title: String, message: String) {
		let action: Action = .showAlert(viewRepresentable: viewRepresentable, title: title, message: message)
		invocations.append(action)
	}
}

// MARK: - Nested data structs
extension RouterSpy {

	enum Action {
		case push(_ viewRepresentable: ViewRepresentable, animated: Bool)
		case pop(animated: Bool)
		case start(root: ViewRepresentable, animated: Bool)
		case openURL(_ url: URL)
		case showAlert(viewRepresentable: ViewRepresentable, title: String, message: String)
	}
}
