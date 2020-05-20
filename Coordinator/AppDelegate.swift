//
//  AppDelegate.swift
//  Coordinator
//
//  Created by nicholas.r.babo on 19/05/20.
//  Copyright © 2020 Nicholas.Babo. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let navigationController = UINavigationController()

        let homeCoordinator = HomeCoordinator(navigationController: navigationController)

        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = homeCoordinator.start(with: .root)
        window.makeKeyAndVisible()

        self.window = window

        return true
    }
}

