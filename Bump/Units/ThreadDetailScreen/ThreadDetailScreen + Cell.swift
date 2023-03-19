//
//  ThreadDetailScreen + Cell.swift
//  Bump
//
//  Created by Anton Cherkasov on 11.03.2023.
//

import UIKit

extension ThreadDetailScreen {

	/// Cell of the post
	final class Cell: UIView, UIContentView {

		private var dateFormatter: DateFormatter = {
			let formatter = DateFormatter()
			formatter.dateStyle = .medium
			formatter.timeStyle = .medium
			return formatter
		}()

		private var currentConfiguration: CellConfiguration!

		var configuration: UIContentConfiguration {
			get {
				currentConfiguration
			}
			set {
				guard let newConfiguration = newValue as? CellConfiguration else {
					return
				}
				apply(newConfiguration)
			}
		}

		// MARK: - UI-Properties

		lazy var mainStack: UIStackView = {
			let view = UIStackView(arrangedSubviews: [headerView, body, footerView])
			view.alignment = .fill
			view.distribution = .fill
			view.axis = .vertical
			view.spacing = 4.0
			return view
		}()

		lazy var headerView: ToolbarView = {
			let view = ToolbarView(leadingViews: [numberLabel],
								  trailingViews: [likesLabel, dislikesLabel])
			return view
		}()

		lazy var footerView: ToolbarView = ToolbarView(leadingViews: [dateLabel], trailingViews: [])

		lazy var numberLabel: UILabel = {
			let view = UILabel()
			view.font = UIFont.preferredFont(forTextStyle: .caption1)
			view.textColor = .secondaryLabel
			return view
		}()

		lazy var likesLabel 	= LabelView(imageSystemName: "bolt.fill", title: "nil")

		lazy var dislikesLabel 	= LabelView(imageSystemName: "hand.thumbsdown.fill", title: nil)

		lazy var dateLabel: UILabel = {
			let view = UILabel()
			view.font = UIFont.preferredFont(forTextStyle: .caption1)
			view.textColor = .secondaryLabel
			return view
		}()

		lazy var body: UITextView = {
			let view = UITextView()
			view.backgroundColor = .clear
			view.textAlignment = .natural
			view.isScrollEnabled = false
			view.isSelectable = true
			view.isUserInteractionEnabled = true
			view.isEditable = false
			view.delegate = self
			view.tintColor = .orange
			return view
		}()

		// MARK: - Initialization

		/// Base initialization
		///
		/// - Parameters:
		///    - configuration: Configuration of the post cell
		init(_ configuration: ThreadDetailScreen.CellConfiguration) {
			super.init(frame: .zero)
			configureConstraints()
			apply(configuration)
		}

		@available(*, unavailable, message: "Use init(imageSystemName: title:)")
		required init?(coder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}

	}
}

// MARK: - Helpers
extension ThreadDetailScreen.Cell {

	func configureConstraints() {
		addSubview(mainStack)
		mainStack.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate(
			[
				mainStack.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
				mainStack.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
				mainStack.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
				mainStack.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
			]
		)
	}

	func apply(_ configuration: ThreadDetailScreen.CellConfiguration) {
		self.currentConfiguration = configuration
		numberLabel.text = "#\(configuration.number)"
		dislikesLabel.title = "\(configuration.likes)"
		likesLabel.title = "\(configuration.dislikes)"
		body.attributedText = configuration.formattedBody
		dateLabel.text = dateFormatter.string(from: configuration.date)
	}
}

// MARK: - UITextViewDelegate
extension ThreadDetailScreen.Cell: UITextViewDelegate {

	func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
		DispatchQueue.main.async { [weak self] in
			(self?.configuration as? ThreadDetailScreen.CellConfiguration)?.linkAction?(URL)
		}
		return false
	}
}
