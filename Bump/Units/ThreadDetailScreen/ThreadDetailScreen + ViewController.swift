//
//  ThreadDetailScreen + ViewController.swift
//  Bump
//
//  Created by Anton Cherkasov on 11.03.2023.
//

import UIKit

/// Interface of the ThreadDetailScreenView output
protocol ThreadDetailScreenViewOutput: ViewControllerOutput {

	/// Fetch threads
	func refreshData()
}

/// Interface of the ThreadDetailScreen view
protocol ThreadDetailScreenViewController: AnyObject {

	/// Start loading animation
	func startProgressAnimation()

	/// Stop loading animation
	func stopProgressAnimation()

	/// Configure view
	///
	/// - Parameters:
	///    - title: Title of the ViewController
	func configure(title: String)

	/// Load snapshot
	func load(_ snapshot: NSDiffableDataSourceSnapshot<String, ThreadDetailScreen.CellModel>)

	/// configure ZeroView
	///
	/// - Parameters:
	///    - model: Model of the ZeroView
	func configurePlaceholder(model: ZeroViewModel?)
}

extension ThreadDetailScreen {

	/// View controller of the ThreadDetailScreen unit
	final class ViewController: UIViewController {

		var presenter: ThreadDetailScreenViewOutput?

		lazy private var datasource = makeDataSource()

		private let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, CellModel> { (cell, indexPath, model) in

			var content = ThreadDetailScreen.CellConfiguration()
			content.body = model.body
			content.likes = model.likes
			content.dislikes = model.dislikes
			content.number = model.id
			cell.contentConfiguration = content
		}

		// MARK: - UI-Properties

		private lazy var collectionView: UICollectionView = {
			var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
			configuration.headerMode = .none
			let layout = UICollectionViewCompositionalLayout.list(using: configuration)
			let refreshControl = UIRefreshControl(frame: .zero, primaryAction: UIAction(handler: { [weak self] action in
				self?.presenter?.refreshData()
			}))
			let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
			view.refreshControl = refreshControl
			return view
		}()

		private lazy var progressView: UIActivityIndicatorView = {
			let view = UIActivityIndicatorView()
			view.style = .medium
			view.isHidden = false
			view.hidesWhenStopped = true
			return view
		}()

		private lazy var placeholderView: ZeroView = {
			let view = ZeroView()
			return view
		}()

		// MARK: - Initialization

		/// Base initialization
		///
		/// - Parameters:
		///    - configure: The closure invoking while initialization. Configure unit here. 
		init(configure: (ThreadDetailScreen.ViewController) -> Void) {
			super.init(nibName: nil, bundle: nil)
			configure(self)
			configureConstraints()
		}

		@available(*, unavailable, message: "init(factory:)")
		required init?(coder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}

	}
}

// MARK: - ViewController Life - Cycle
extension ThreadDetailScreen.ViewController {

	override func loadView() {
		self.view = UIView()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		presenter?.viewController(didChangeState: .didLoad)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		presenter?.viewController(didChangeState: .willAppear)
	}
}

// MARK: - Helpers
extension ThreadDetailScreen.ViewController {

	typealias CellModel = ThreadDetailScreen.CellModel

	func configureConstraints() {

		[collectionView, placeholderView, progressView].forEach {
			view.addSubview($0)
			$0.translatesAutoresizingMaskIntoConstraints = false
		}

		NSLayoutConstraint.activate(
			[
				collectionView.topAnchor.constraint(equalTo: view.topAnchor),
				collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
				collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
				collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

				progressView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
				progressView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

				placeholderView.topAnchor.constraint(equalTo: view.topAnchor),
				placeholderView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
				placeholderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
				placeholderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			]
		)
	}

	func makeDataSource() -> UICollectionViewDiffableDataSource<String, CellModel> {
		let source = UICollectionViewDiffableDataSource<String, CellModel>(collectionView: collectionView) { [weak self] collectionView, indexPath, item in
			guard let self else { return UICollectionViewCell() }
			return collectionView.dequeueConfiguredReusableCell(using: self.cellRegistration,
																for: indexPath,
																item: item)
		}
		return source
	}
}

// MARK: - ThreadDetailScreenViewController
extension ThreadDetailScreen.ViewController: ThreadDetailScreenViewController {

	func configure(title: String) {
		self.title = title
	}

	func startProgressAnimation() {
		progressView.startAnimating()
	}

	func stopProgressAnimation() {
		progressView.stopAnimating()
		DispatchQueue.main.async {
			self.collectionView.refreshControl?.endRefreshing()
		}
	}

	func load(_ snapshot: NSDiffableDataSourceSnapshot<String, ThreadDetailScreen.CellModel>) {
		placeholderView.isHidden = true
		datasource.apply(snapshot)
		DispatchQueue.main.async {
			self.collectionView.refreshControl?.endRefreshing()
		}
	}

	func configurePlaceholder(model: ZeroViewModel?) {
		guard let model else {
			placeholderView.isHidden = true
			return
		}
		placeholderView.isHidden = false
		placeholderView.model = model
	}
}
