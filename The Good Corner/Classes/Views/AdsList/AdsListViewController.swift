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
//        tableView.prefetchDataSource = self
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
        }

        viewModel.errorOccured = { (error) in
            print(error)
        }

        viewModel.updateCategoriesAndAds()
    }

    private func layoutSubviews() {
        view.addSubview(collectionView)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: tableView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 50),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
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
