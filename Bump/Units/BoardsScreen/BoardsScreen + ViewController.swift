//
//  ViewController.swift
//  Bump
//
//  Created by Anton Cherkasov on 09.02.2023.
//

import UIKit

/// Interface of the BoardsScreenView output
protocol BoardsScreenViewOutput: ViewControllerOutput {

	/// User select cell item with identifier
	func didSelect(_ identifier: String)
}

/// Interface of the BoardsScreen view
protocol BoardsScreenViewController: AnyObject {

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
	func load(_ snapshot: NSDiffableDataSourceSnapshot<BoardsScreen.HeaderModel, BoardsScreen.CellModel>)
}

extension BoardsScreen {

	/// View controller of the BoardsScreen unit
	final class ViewController: UIViewController {

		var presenter: BoardsScreenViewOutput?

		lazy private var datasource = makeDataSource()

		private let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, CellModel> { (cell, indexPath, model) in

			var content = UIListContentConfiguration.subtitleCell()
			content.text = model.title
			content.secondaryTextProperties.color = .secondaryLabel
			cell.contentConfiguration = content
			cell.accessories = [.disclosureIndicator(displayed: .always),
								.label(text: model.detail, displayed: .always)]
		}

		private var headerRegistration: UICollectionView.SupplementaryRegistration<UICollectionViewListCell>!

		// MARK: - UI-Properties

		lazy var collectionView: UICollectionView = {
			var configuration = UICollectionLayoutListConfiguration(appearance: .sidebar)
			configuration.headerMode = .supplementary
			let layout = UICollectionViewCompositionalLayout.list(using: configuration)
			return UICollectionView(frame: .zero, collectionViewLayout: layout)
		}()

		lazy var progressView: UIActivityIndicatorView = {
			let view = UIActivityIndicatorView()
			view.style = .medium
			view.hidesWhenStopped = true
			return view
		}()

		// MARK: - Initialization

		init(configure: (BoardsScreen.ViewController) -> Void) {
			super.init(nibName: nil, bundle: nil)
			configure(self)
			configureConstraints()
			headerRegistration = makeHeaderRegistration()
			collectionView.delegate = self
		}

		@available(*, unavailable, message: "init(factory:)")
		required init?(coder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}

	}
}

// MARK: - ViewController Life - Cycle
extension BoardsScreen.ViewController {

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
extension BoardsScreen.ViewController {

	typealias HeaderModel = BoardsScreen.HeaderModel

	typealias CellModel = BoardsScreen.CellModel

	func configureConstraints() {

		[collectionView, progressView].forEach {
			view.addSubview($0)
			$0.translatesAutoresizingMaskIntoConstraints = false
		}

		NSLayoutConstraint.activate(
			[
				collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
				collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
				collectionView.topAnchor.constraint(equalTo: view.topAnchor),
				collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

				progressView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
				progressView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
			]
		)
	}

	func makeHeaderRegistration() -> UICollectionView.SupplementaryRegistration<UICollectionViewListCell> {
		let elementKind = UICollectionView.elementKindSectionHeader
		return UICollectionView.SupplementaryRegistration<UICollectionViewListCell>(elementKind: elementKind) { (headerView, elementKind, indexPath) in

			let headerItem = self.datasource.snapshot().sectionIdentifiers[indexPath.section]

			var configuration = headerView.defaultContentConfiguration()
			configuration.text = headerItem.title
			configuration.textProperties.font = UIFont.preferredFont(forTextStyle: .headline)
			configuration.textProperties.color = AppTheme.accentColor
			configuration.directionalLayoutMargins = .init(top: 24.0, leading: 0.0, bottom: 12.0, trailing: 0.0)

			headerView.contentConfiguration = configuration
		}
	}


	func makeDataSource() -> UICollectionViewDiffableDataSource<HeaderModel, CellModel> {
		let source = UICollectionViewDiffableDataSource<HeaderModel, CellModel>(collectionView: collectionView) { [weak self] collectionView, indexPath, item in
			guard let self else { return UICollectionViewCell() }
			return collectionView.dequeueConfiguredReusableCell(using: self.cellRegistration,
																for: indexPath,
																item: item)
		}
		source.supplementaryViewProvider = { [weak self] (collectionView, elementKind, indexPath) in
			guard let self else { return UICollectionReusableView() }
			if elementKind == UICollectionView.elementKindSectionHeader {
				return collectionView.dequeueConfiguredReusableSupplementary(using: self.headerRegistration, for: indexPath)
			}
			return nil
		}
		return source
	}
}

// MARK: - UICollectionViewDelegate
extension BoardsScreen.ViewController: UICollectionViewDelegate {

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let snapshot = datasource.snapshot()
		let section = snapshot.sectionIdentifiers[indexPath.section]
		let item = snapshot.itemIdentifiers(inSection: section)[indexPath.item]
		presenter?.didSelect(item.id)
	}

}

// MARK: - BoardsScreenViewController
extension BoardsScreen.ViewController: BoardsScreenViewController {

	func configure(title: String) {
		self.title = title
	}

	func startProgressAnimation() {
		progressView.startAnimating()
	}

	func stopProgressAnimation() {
		progressView.stopAnimating()
	}

	func load(_ snapshot: NSDiffableDataSourceSnapshot<BoardsScreen.HeaderModel, BoardsScreen.CellModel>) {
		datasource.apply(snapshot)
	}
}
