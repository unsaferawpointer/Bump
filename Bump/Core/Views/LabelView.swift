//
//  LabelView.swift
//  Bump
//
//  Created by Anton Cherkasov on 25.02.2023.
//

import UIKit

final class LabelView: UIView {

	var imageSystemName: String {
		didSet {
			let image = UIImage(systemName: imageSystemName)
			imageView.image = image
		}
	}

	var title: String? {
		didSet {
			label.text = title
		}
	}

	// MARK: - UI-Properties

	lazy var label: UILabel = {
		let view = UILabel()
		view.textColor = .secondaryLabel
		view.text = title
		view.font = UIFont.preferredFont(forTextStyle: .caption1)
		return view
	}()

	lazy var imageView: UIImageView = {
		let view = UIImageView()
		view.contentMode = .scaleAspectFit
		view.image = UIImage(systemName: imageSystemName)
		view.preferredSymbolConfiguration = UIImage.SymbolConfiguration(textStyle: .caption1)
		view.tintColor = .secondaryLabel
		return view
	}()

	// MARK: - Initialization

	init(imageSystemName: String, title: String? = nil) {
		self.imageSystemName = imageSystemName
		self.title = title
		super.init(frame: .zero)
		configureConstraints()
	}

	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

// MARK: - Helpers
extension LabelView {

	func configureConstraints() {
		[imageView, label].forEach {
			addSubview($0)
			$0.translatesAutoresizingMaskIntoConstraints = false
		}

		label.setContentHuggingPriority(.defaultLow, for: .horizontal)
		label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

		imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
		imageView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

		NSLayoutConstraint.activate(
			[
				imageView.topAnchor.constraint(equalTo: topAnchor),
				imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
				imageView.bottomAnchor.constraint(equalTo: bottomAnchor),

				label.centerYAnchor.constraint(equalTo: centerYAnchor),
				label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 4.0),
				label.trailingAnchor.constraint(equalTo: trailingAnchor)
			]
		)
	}
}
