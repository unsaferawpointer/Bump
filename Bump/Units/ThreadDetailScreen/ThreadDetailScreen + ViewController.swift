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

	typealias Snapshot = NSDiffableDataSourceSnapshot<String, ThreadDetailScreen.PostModel>

	/// Start loading animation
	func startProgressAnimation()

	/// Stop loading animation
	func stopProgressAnimation()

	/// Configure view
	///
	/// - Parameters:
	///    - title: Title of the ViewController
	func configure(title: String)

	/// Configure snasphot
	///
	/// - Parameters:
	///    - snapshot: New snapshot
	func configure(snapshot: Snapshot)

	/// Scroll to specific post
	///
	/// - Parameters:
	///    - postNumber: Number of the post
	func scrollTo(postNumber: Int)
}

extension ThreadDetailScreen {

	/// View controller of the ThreadDetailScreen unit
	final class ViewController: UIViewController {

		var presenter: ThreadDetailScreenViewOutput?

		lazy private var datasource = makeDataSource()

		private let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, CellModel> { (cell, indexPath, model) in

			var content = ThreadDetailScreen.CellConfiguration()
			content.body = model.body
			content.formattedBody = model.formattedBody
			content.likes = model.likes
			content.dislikes = model.dislikes
			content.number = model.id
			content.linkAction = model.linkAction
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
			view.allowsSelection = false
			return view
		}()

		private lazy var progressView: UIActivityIndicatorView = {
			let view = UIActivityIndicatorView()
			view.style = .medium
			view.isHidden = false
			view.hidesWhenStopped = true
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

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		presenter?.viewController(didChangeState: .didDisappear)
	}
}

// MARK: - Helpers
extension ThreadDetailScreen.ViewController {

	typealias CellModel = ThreadDetailScreen.PostModel

	func configureConstraints() {

		[collectionView, progressView].forEach {
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
				progressView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
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

	typealias Snapshot = NSDiffableDataSourceSnapshot<String, ThreadDetailScreen.PostModel>

	func configure(snapshot: Snapshot) {
		datasource.apply(snapshot)
	}

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

	func scrollTo(postNumber: Int) {
		let snapshot = datasource.snapshot(for: "")
		guard
			let item = snapshot.items.first(where: { $0.id == postNumber } ),
			let indexPath = datasource.indexPath(for: item)
		else {
			return
		}
		collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
	}
}
