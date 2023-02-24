//
//  ViewControllerOutput.swift
//  Bump
//
//  Created by Anton Cherkasov on 23.02.2023.
//

/// Interface of the unit ViewController
protocol ViewControllerOutput: AnyObject {
	/// Notificate about new ViewController state
	func viewController(didChangeState state: LifeCycleState)
}

/// Life cycle state of the UIViewController
enum LifeCycleState {
	case didLoad
	case willAppear
	case didAppear
	case willDisappear
	case didDisappear
}
