//
//  ThreadsScreenPlaceholdersFactoryMock.swift
//  BumpTests
//
//  Created by Anton Cherkasov on 02.03.2023.
//

@testable import Bump

final class ThreadsScreenPlaceholdersFactoryMock {
	var modelStub = ZeroViewModel(title: "")
}

// MARK: - ThreadsScreenPlaceholdersFactory
extension ThreadsScreenPlaceholdersFactoryMock: ThreadsScreenPlaceholdersFactory {

	func makeModel(for error: Error, action: @escaping () -> Void) -> ZeroViewModel {
		return modelStub
	}
}
