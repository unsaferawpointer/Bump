//
//  ThreadDetailScreenPlaceholdersFactoryMock.swift
//  BumpTests
//
//  Created by Anton Cherkasov on 02.03.2023.
//

@testable import Bump

final class ThreadDetailScreenPlaceholdersFactoryMock {
	var modelStub = ZeroViewModel(title: "")
}

// MARK: - ThreadDetailScreenPlaceholdersFactory
extension ThreadDetailScreenPlaceholdersFactoryMock: ThreadDetailScreenPlaceholdersFactory {

	func makeModel(for error: Error) -> ZeroViewModel {
		return modelStub
	}
}
