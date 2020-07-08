//
//  AdsListViewController.swift
//  The Good Corner
//
//  Created by Olivier Duménil on 08/07/2020.
//  Copyright © 2020 Olivier Duménil. All rights reserved.
//

import UIKit

protocol AdsListCoordinator {

}

class AdsListViewController: UIViewController {

    let viewModel: AdsListViewModel

    let coordinator: AdsListCoordinator

    init(viewModel: AdsListViewModel,
         coordinator: AdsListCoordinator,
         nibName: String? = nil,
         bundle: Bundle? = nil) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nibName, bundle: bundle)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
//        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.estimatedItemSize = .init(width: 50, height: 50)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.allowsMultipleSelection = false
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private lazy var loadingRetryView: LoadingRetryView = {
        let view = LoadingRetryView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.retryTitle = NSLocalizedString("retry", comment: "")
        view.retryAction = reload
        return view
    }()

    private var prefetchedIndexes = Set<IndexPath>()

    override func viewDidLoad() {
        super.viewDidLoad()

        layoutSubviews()

        tableView.register(AdTableViewCell.self, forCellReuseIdentifier: AdTableViewCell.identifier)
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)

        viewModel.didUpdateAds = { [weak self] in
            self?.tableView.reloadData()
        }

        viewModel.didUpdateCategories = { [weak self] in
            self?.collectionView.reloadData()
            self?.loadingRetryView.state = .none
        }

        viewModel.errorOccured = { [weak self] (error) in
            self?.loadingRetryView.state = .error(message: error.localizedDescription)
        }

        reload()
    }

    private func reload() {
        prefetchedIndexes.removeAll()
        loadingRetryView.state = .loading
        viewModel.updateCategoriesAndAds()
    }

    private func layoutSubviews() {
        view.addSubview(collectionView)
        view.addSubview(tableView)
        view.addSubview(loadingRetryView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: tableView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 50),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingRetryView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingRetryView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loadingRetryView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingRetryView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

}

// MARK: - UITableViewDataSource
extension AdsListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.ads.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AdTableViewCell.identifier, for: indexPath)

        cell.textLabel?.text = viewModel.ads[indexPath.row].title
        cell.imageView?.image = viewModel.ads[indexPath.row].thumbImage

        prefetchImage(indexPath: indexPath)

        return cell
    }
}

// MARK: - UICollectionViewDataSource
extension AdsListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as? CategoryCollectionViewCell else {
            fatalError("Incorrect cell dequeued")
        }
        cell.setupWithCategory(viewModel.categories[indexPath.item])
        return cell
    }
}

// MARK: - UITableViewDataSourcePrefetching
extension AdsListViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach(prefetchImage(indexPath:))
        indexPaths.forEach { [weak self] (indexPath) in
            guard let self = self, self.prefetchedIndexes.contains(indexPath) == false else { return }

            self.prefetchedIndexes.insert(indexPath)
            self.viewModel.getThumbnailImageForAd(self.viewModel.ads[indexPath.row]) { (_) in
                self.tableView.reloadRows(at: [indexPath], with: .none)
            }
        }
    }

    private func prefetchImage(indexPath: IndexPath) {
        guard prefetchedIndexes.contains(indexPath) == false else { return }

        prefetchedIndexes.insert(indexPath)
        viewModel.getThumbnailImageForAd(viewModel.ads[indexPath.row]) { [weak self] (_) in
            self?.tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
}

// MARK: - UICollectionViewDelegate
extension AdsListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selected = viewModel.categories[indexPath.item]
        if viewModel.filterCategory == selected {
            viewModel.filterCategory = nil
        } else {
            viewModel.filterCategory = selected
        }
    }
}

extension MainCoordinator: AdsListCoordinator { }
