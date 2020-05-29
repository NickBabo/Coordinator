//
//  Protocols.swift
//  Coordinator
//
//  Created by nicholas.r.babo on 19/05/20.
//  Copyright © 2020 Nicholas.Babo. All rights reserved.
//

import UIKit

protocol CoordinatorType {
    var navigationController: UINavigationController { get }
    func start(with navigation: TransitionType) -> UIViewController
}

public protocol TabCoordinator {
    var childCoordinators: [Coordinator] { get }
}
