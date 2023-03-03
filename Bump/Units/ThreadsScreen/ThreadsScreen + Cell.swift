//
//  ThreadsScreen + Cell.swift
//  Bump
//
//  Created by Anton Cherkasov on 25.02.2023.
//

import UIKit

extension ThreadsScreen {

	/// Cell of the thread
	final class Cell: UIView, UIContentView {

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

		lazy var mainStack: UIStackView = {
			let view = UIStackView(arrangedSubviews: [title, headerStack])
			view.alignment = .fill
			view.distribution = .fill
			view.axis = .vertical
			view.spacing = 4.0
			return view
		}()

		lazy var headerStack: UIStackView = {
			let makeStack: UIStackView = {
				let view = UIStackView()
				view.spacing = 4.0
				view.addArrangedSubview(repliesImageView)
				view.addArrangedSubview(repliesLabel)
				view.addArrangedSubview(viewsImageView)
				view.addArrangedSubview(viewsLabel)
				view.axis = .horizontal
				return view
			}()
			let view = UIStackView(arrangedSubviews: [makeStack])
			view.axis = .vertical
			view.distribution = .fill
			view.alignment = .trailing
			return view
		}()

		lazy var repliesLabel: UILabel = {
			let view = UILabel()
			view.font = UIFont.preferredFont(forTextStyle: .caption1)
			view.textColor = .secondaryLabel
			view.text = "345"
			return view
		}()

		lazy var repliesImageView: UIImageView = {
			let view = UIImageView()
			view.contentMode = .scaleAspectFit
			view.preferredSymbolConfiguration = UIImage.SymbolConfiguration(textStyle: .caption1)
			view.tintColor = .secondaryLabel
			view.image = UIImage(systemName: "bubble.right")
			return view
		}()

		lazy var viewsLabel: UILabel = {
			let view = UILabel()
			view.font = UIFont.preferredFont(forTextStyle: .caption1)
			view.textColor = .secondaryLabel
			view.text = "345"
			return view
		}()

		lazy var viewsImageView: UIImageView = {
			let view = UIImageView()
			view.contentMode = .scaleAspectFit
			view.preferredSymbolConfiguration = UIImage.SymbolConfiguration(textStyle: .caption1)
			view.tintColor = .secondaryLabel
			view.image = UIImage(systemName: "eye")
			return view
		}()

		lazy var title: UILabel = {
			let view = UILabel()
			view.numberOfLines = 3
			view.textAlignment = .natural
			view.lineBreakMode = .byTruncatingTail
			return view
		}()

		// MARK: - Initialization

		init(_ configuration: ThreadsScreen.CellConfiguration) {
			super.init(frame: .zero)
			configureConstraints()
			apply(configuration)
		}

		@available(*, unavailable, message: "Use init(imageSystemName: title:)")
		required init?(coder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}

		// MARK: - Helpers
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

		func apply(_ configuration: ThreadsScreen.CellConfiguration) {
			self.currentConfiguration = configuration
			viewsLabel.text = "\(configuration.viewsCount)"
			repliesLabel.text = "\(configuration.repliesCount)"
			title.text = configuration.title
		}

	}
}
