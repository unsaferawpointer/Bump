//
//  ThreadsScreen + ScreensFactory.swift
//  Bump
//
//  Created by Anton Cherkasov on 28.02.2023.
//

protocol ThreadsScreenPlaceholdersFactory {
	func makeModel(for error: Error) -> ZeroViewModel
}

extension ThreadsScreen {

	final class PlaceholdersFactory {

	}
}

// MARK: - ThreadsScreenPlaceholdersFactory
extension ThreadsScreen.PlaceholdersFactory: ThreadsScreenPlaceholdersFactory {

	func makeModel(for error: Error) -> ZeroViewModel {
		<#code#>
	}
}
