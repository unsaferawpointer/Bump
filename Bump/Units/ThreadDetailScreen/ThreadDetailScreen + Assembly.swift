//
//  ThreadDetailScreen + Assembly.swift
//  Bump
//
//  Created by Anton Cherkasov on 25.03.2023.
//

import UIKit

protocol ThreadDetailScreenAssembly {

	func makeMainScreen(_ payload: ThreadDetailScreen.Payload, output: ThreadDetailScreenOutput) -> UIViewController
	func makePlaceholderScreen(_ model: ZeroViewModel) -> UIViewController
}

extension ThreadDetailScreen {

	final class Assembly { }
}

// MARK: - ThreadDetailScreenAssembly
extension ThreadDetailScreen.Assembly: ThreadDetailScreenAssembly {

	func makeMainScreen(_ payload: ThreadDetailScreen.Payload, output: ThreadDetailScreenOutput) -> UIViewController {
		return ThreadDetailScreen.ViewController { viewController in
			let presenter = ThreadDetailScreen.Presenter()
			let interactor = ThreadDetailScreen.Interactor(payload: payload)
			interactor.output = output
			presenter.interactor = interactor
			interactor.presenter = presenter
			viewController.presenter = presenter
			presenter.view = viewController
		}
	}

	func makePlaceholderScreen(_ model: ZeroViewModel) -> UIViewController {
		return UIViewController()
	}
}
