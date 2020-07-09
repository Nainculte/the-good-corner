//
//  MainCoordinator.swift
//  The Good Corner
//
//  Created by Olivier Duménil on 07/07/2020.
//  Copyright © 2020 Olivier Duménil. All rights reserved.
//

import UIKit

class MainCoordinator {

    private let window: UIWindow

    private let adsRepository: AdsRepository

    private lazy var navigationController: UINavigationController = {
        let navController = UINavigationController(rootViewController: rootController)
        navController.navigationBar.isTranslucent = false
        return navController
    }()

    private lazy var rootController: AdsListViewController = {
        let viewModel = AdsListViewModel(repository: adsRepository)
        let controller = AdsListViewController(viewModel: viewModel, coordinator: self)
        return controller
    }()

    init(window: UIWindow, adsRepository: AdsRepository) {
        self.window = window
        self.adsRepository = adsRepository

        self.adsRepository.delegate = self
    }

    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    func didSelectAd(_ ad: Ad) {
        let controller = detailController(for: ad)
        navigationController.pushViewController(controller, animated: true)
    }

    private func detailController(for ad: Ad) -> AdDetailViewController {
        let viewModel = AdDetailViewModel(repository: adsRepository, ad: ad)
        let controller = AdDetailViewController(viewModel: viewModel, coordinator: self)
        return controller
    }

}

extension MainCoordinator: AdsRepositoryDelegate {
    func adsRepository(_ repository: AdsRepository, didUpdate categories: [Category]) {
        rootController.viewModel.adsRepository(repository, didUpdate: categories)
    }

    func adsRepository(_ repository: AdsRepository, didUpdate ads: [Ad]) {
        rootController.viewModel.adsRepository(repository, didUpdate: ads)
    }

    func adsRepository(_ repository: AdsRepository, failedFetching error: APIError) {
        rootController.viewModel.adsRepository(repository, failedFetching: error)
    }
}
