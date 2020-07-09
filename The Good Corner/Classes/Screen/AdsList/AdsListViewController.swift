//
//  AdsListViewController.swift
//  The Good Corner
//
//  Created by Olivier Duménil on 08/07/2020.
//  Copyright © 2020 Olivier Duménil. All rights reserved.
//

import UIKit

protocol AdsListCoordinator: class {

    func didSelectAd(_ ad: Ad)

}

class AdsListViewController: ViewController<AdsListViewModel, AdsListCoordinator> {

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.estimatedItemSize = .init(width: 50, height: 50)
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
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
            self?.prefetchedIndexes.removeAll()
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
            collectionView.heightAnchor.constraint(equalToConstant: 70),
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AdTableViewCell.identifier, for: indexPath) as? AdTableViewCell else {
            fatalError("Incorrect cell dequeued")
        }

        cell.ad = viewModel.ads[indexPath.row]
        prefetchImage(indexPath: indexPath)
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
        let ad = viewModel.ads[indexPath.row]
        guard prefetchedIndexes.contains(indexPath) == false else { return }

        prefetchedIndexes.insert(indexPath)

        guard ad.thumbImage == nil else { return }

        viewModel.getThumbnailImageForAd(ad) { [weak self] (_) in
            self?.tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
}

// MARK: - UITableViewDelegate
extension AdsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        coordinator.didSelectAd(viewModel.ads[indexPath.row])
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

// MARK: - UICollectionViewDelegate
extension AdsListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selected = viewModel.categories[indexPath.item]
        if viewModel.filterCategory == selected {
            viewModel.filterCategory = nil
            collectionView.deselectItem(at: indexPath, animated: true)
        } else {
            viewModel.filterCategory = selected
        }
    }
}

extension MainCoordinator: AdsListCoordinator { }
