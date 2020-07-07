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

    private lazy var navigationController: UINavigationController = {
        return UINavigationController(rootViewController: UIViewController())
    }()

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

}
