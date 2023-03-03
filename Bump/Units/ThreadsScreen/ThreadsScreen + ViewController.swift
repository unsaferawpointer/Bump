//
//  ThreadsScreen + ViewController.swift
//  Bump
//
//  Created by Anton Cherkasov on 24.02.2023.
//

import UIKit

/// Interface of the ThreadsScreenView output
protocol ThreadsScreenViewOutput: ViewControllerOutput {

	/// User select cell item with identifier
	func didSelect(_ identifier: Int)

	/// Fetch threads
	func refreshData()
}

/// Interface of the ThreadsScreen view
protocol ThreadsScreenViewController: AnyObject {

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
	func load(_ snapshot: NSDiffableDataSourceSnapshot<String, ThreadsScreen.CellModel>)

	/// configure ZeroView
	///
	/// - Parameters:
	///    - model: Model of the ZeroView
	func configurePlaceholder(model: ZeroViewModel?)
}

extension ThreadsScreen {

	/// View controller of the ThreadsScreen unit
	final class ViewController: UIViewController {

		var presenter: ThreadsScreenViewOutput?

		lazy private var datasource = makeDataSource()

		private let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, CellModel> { (cell, indexPath, model) in

			var content = ThreadsScreen.CellConfiguration()
			content.title = model.title
			content.viewsCount = model.views
			content.repliesCount = model.replies
			cell.contentConfiguration = content
			cell.accessories = [.disclosureIndicator(displayed: .always)]
		}

		// MARK: - UI-Properties

		lazy var collectionView: UICollectionView = {
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

		lazy var progressView: UIActivityIndicatorView = {
			let view = UIActivityIndicatorView()
			view.style = .medium
			view.isHidden = false
			view.hidesWhenStopped = true
			return view
		}()

		lazy var placeholderView: ZeroView = {
			let view = ZeroView()
			return view
		}()

		// MARK: - Initialization

		init(configure: (ThreadsScreen.ViewController) -> Void) {
			super.init(nibName: nil, bundle: nil)
			configure(self)
			configureConstraints()
			collectionView.delegate = self
		}

		@available(*, unavailable, message: "init(factory:)")
		required init?(coder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}

	}
}

// MARK: - ViewController Life - Cycle
extension ThreadsScreen.ViewController {

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
extension ThreadsScreen.ViewController {

	typealias CellModel = ThreadsScreen.CellModel

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

// MARK: - UICollectionViewDelegate
extension ThreadsScreen.ViewController: UICollectionViewDelegate {

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let snapshot = datasource.snapshot()
		let section = snapshot.sectionIdentifiers[indexPath.section]
		let item = snapshot.itemIdentifiers(inSection: section)[indexPath.item]
		presenter?.didSelect(item.id)
	}

}

// MARK: - ThreadsScreenViewController
extension ThreadsScreen.ViewController: ThreadsScreenViewController {

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

	func load(_ snapshot: NSDiffableDataSourceSnapshot<String, ThreadsScreen.CellModel>) {
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
