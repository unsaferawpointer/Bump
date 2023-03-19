//
//  DeeplinkManagerMock.swift
//  BumpTests
//
//  Created by Anton Cherkasov on 28.03.2023.
//

import Foundation
@testable import Bump

final class DeeplinkManagerStub {
	var stub: DeeplinkEndpoint?
}

// MARK: - DeeplinkManagerProtocol
extension DeeplinkManagerStub: DeeplinkManagerProtocol {

	func makeDeeplinkIfPossible(_ url: URL) -> DeeplinkEndpoint? {
		return stub
	}
}
