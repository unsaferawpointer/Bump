//
//  ZeroView.swift
//  Bump
//
//  Created by Anton Cherkasov on 26.02.2023.
//

import UIKit

struct ZeroViewModel {

	var title: String
	var message: String?

	var image: UIImage?

	var action: (() -> Void)?
	var buttonTitle: String?
}

class ZeroView: UIView {

	var model: ZeroViewModel? {
		didSet {
			imageView.image = model?.image
			titleLabel.text = model?.title
			messageLabel.text = model?.message
			let isVisible = model?.action != nil
			button.isHidden = !isVisible
			button.setTitle(model?.buttonTitle, for: .normal)
		}
	}

	// MARK: - UI-Properties

	lazy var imageView: UIImageView = {
		let view = UIImageView()
		view.contentMode = .scaleAspectFit
		view.tintColor = .secondaryLabel
		view.preferredSymbolConfiguration = UIImage.SymbolConfiguration(scale: .large)
		return view
	}()

	lazy var titleLabel: UILabel = {
		let view = UILabel()
		view.font = UIFont.preferredFont(forTextStyle: .headline)
		view.textColor = .label
		return view
	}()

	lazy var messageLabel: UILabel = {
		let view = UILabel()
		view.font = UIFont.preferredFont(forTextStyle: .caption1)
		view.textColor = .secondaryLabel
		return view
	}()

	lazy var button: UIButton = {
		let view = UIButton(type: .system)
		view.setTitleColor(AppTheme.accentColor, for: .normal)
		view.addTarget(self, action: #selector(buttonDidTapped(_:)), for: .touchUpInside)
		return view
	}()

	lazy var stack: UIStackView = {
		let view = UIStackView(arrangedSubviews: [imageView, titleLabel, messageLabel, button])
		view.spacing =  8.0
		view.alignment = .center
		view.axis = .vertical
		return view
	}()

	// MARK: - Initialization

	init() {
		super.init(frame: .zero)
		configureConstraints()
	}

	@available(*, unavailable, message: "Use init()")
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: - Helpers
extension ZeroView {

	@objc
	func buttonDidTapped(_ sender: UIButton) {
		model?.action?()
	}

	func configureConstraints() {
		addSubview(stack)
		stack.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate(
			[
				stack.centerXAnchor.constraint(equalTo: centerXAnchor),
				stack.centerYAnchor.constraint(equalTo: centerYAnchor)
			]
		)
	}
}
