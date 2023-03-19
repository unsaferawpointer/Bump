//
//  CoordinatableSpy.swift
//  BumpTests
//
//  Created by Anton Cherkasov on 26.03.2023.
//

@testable import Bump

final class CoordinatableSpy {
	var invocations: [Action] = []
}

// MARK: - Coordinatable
extension CoordinatableSpy: Coordinatable {

	func start() {
		invocations.append(.start)
	}
}

extension CoordinatableSpy {

	enum Action {
		case start
	}
}
