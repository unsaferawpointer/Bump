//
//  LabelView.swift
//  Bump
//
//  Created by Anton Cherkasov on 25.02.2023.
//

import UIKit

final class LabelView: UIStackView {

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

	lazy var stack: UIStackView = {
		let view = UIStackView(arrangedSubviews: [imageView, label])
		view.axis = .horizontal
		view.distribution = .fill
		view.alignment = .lastBaseline
		return view
	}()

	lazy var label: UILabel = {
		let view = UILabel()
		return view
	}()

	lazy var imageView: UIImageView = {
		let view = UIImageView()
		view.contentMode = .scaleAspectFit
		return view
	}()

	// MARK: - Initialization

	init(imageSystemName: String, title: String? = nil) {
		self.imageSystemName = imageSystemName
		self.title = title
		super.init(frame: .zero)
		addArrangedSubview(imageView)
		addSubview(label)
	}

	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
