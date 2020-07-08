//
//  AppDelegate.swift
//  The Good Corner
//
//  Created by Olivier Duménil on 06/07/2020.
//  Copyright © 2020 Olivier Duménil. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private var coordinator: MainCoordinator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let window = UIWindow(frame: UIScreen.main.bounds)

        let requestSender = RequestManager()
        let api = APIManager(requestSender: requestSender)
        let adsManager = AdsManager(api: api)

        coordinator = MainCoordinator(window: window, adsRepository: adsManager)
        coordinator.start()

        return true
    }


}

