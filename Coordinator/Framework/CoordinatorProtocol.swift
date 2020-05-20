//
//  Protocols.swift
//  Coordinator
//
//  Created by nicholas.r.babo on 19/05/20.
//  Copyright © 2020 Nicholas.Babo. All rights reserved.
//

import UIKit

protocol CoordinatorType {
    var stateStack: [CoordinatorState] { get set }
    var navigationController: UINavigationController { get }
    func start(with navigation: TransitionType) -> UIViewController
}

extension CoordinatorType {
    var currentState: CoordinatorState? {
        return stateStack.last
    }
}
