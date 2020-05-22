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

        let appearance = UINavigationBar.appearance()
        appearance.barTintColor = UIColor(red: 1.00, green: 0.80, blue: 0.33, alpha: 1.00)
        appearance.tintColor = UIColor(red: 0.77, green: 0.51, blue: 1.00, alpha: 1.00)

        let navigationController = UINavigationController()

        let homeCoordinator = HomeCoordinator(navigationController: navigationController)

        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = homeCoordinator.start(with: .root)
        window.makeKeyAndVisible()

        self.window = window

        return true
    }
}

