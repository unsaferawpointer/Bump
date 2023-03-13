//
//  ToolbarView.swift
//  Bump
//
//  Created by Anton Cherkasov on 11.03.2023.
//

import UIKit

final class ToolbarView: UIView {

	// MARK: - UI-properties

	private var leadingStack: UIStackView = {
		let view = UIStackView(arrangedSubviews: [])
		view.axis = .horizontal
		view.distribution = .fill
		view.spacing = 24.0
		return view
	}()

	private var trailingStack: UIStackView = {
		let view = UIStackView(arrangedSubviews: [])
		view.axis = .horizontal
		view.distribution = .fill
		view.spacing = 24.0
		return view
	}()

	// MARK: - Initialization

	init(leadingViews: [UIView], trailingViews: [UIView]) {
		self.leadingStack = UIStackView(arrangedSubviews: leadingViews)
		self.trailingStack = UIStackView(arrangedSubviews: trailingViews)
		super.init(frame: .zero)
		configureUserInterface()
		configureConstraints()
	}

	@available(*, unavailable, message: "Use init(leadingViews: trailingViews:)")
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}

// MARK: - Helpers
private extension ToolbarView {

	func configureUserInterface() {
		leadingStack.spacing = 8.0
		trailingStack.spacing = 8.0
	}

	func configureConstraints() {
		[leadingStack, trailingStack].forEach {
			addSubview($0)
			$0.translatesAutoresizingMaskIntoConstraints = false
		}

		NSLayoutConstraint.activate(
			[
				leadingStack.topAnchor.constraint(equalTo: topAnchor),
				leadingStack.leadingAnchor.constraint(equalTo: leadingAnchor),
				leadingStack.bottomAnchor.constraint(equalTo: bottomAnchor),

				trailingStack.topAnchor.constraint(equalTo: topAnchor),
				trailingStack.trailingAnchor.constraint(equalTo: trailingAnchor),
				trailingStack.bottomAnchor.constraint(equalTo: bottomAnchor)
			]
		)

	}
}
