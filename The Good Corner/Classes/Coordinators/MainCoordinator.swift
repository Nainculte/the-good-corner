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
        return UINavigationController(rootViewController: rootController)
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
