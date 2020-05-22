//
//  Flow1Coordinator.swift
//  Coordinator
//
//  Created by nicholas.r.babo on 20/05/20.
//  Copyright © 2020 Nicholas.Babo. All rights reserved.
//

import UIKit

final class Flow1Coordinator: Coordinator {

    override func start(with navigation: TransitionType) -> UIViewController {
        let viewController = Flow1ViewController()
        viewController.delegate = self

        switch navigation {
        case .present:
            let navigationcontroller = UINavigationController()
            navigationcontroller.viewControllers = [viewController]
            return navigate(to: navigationcontroller, with: navigation)
        case .push:
            return navigate(to: viewController, with: navigation)
        default:
            return viewController
        }
    }
}

extension Flow1Coordinator: ViewControllerDelegate {
    func wantsToPush() {
        let viewController = ViewController()
        viewController.delegate = self
        viewController.view.backgroundColor = .blue
        navigate(to: viewController, with: .push)
    }

    func wantsToPresent() {
        let viewController = ViewController()
        viewController.delegate = self
        viewController.view.backgroundColor = .green
        navigate(to: viewController, with: .present())
    }

    func wantsToPushCoordinator() {
        let coordinator = Flow1Coordinator(navigationController: navigationController)
        navigate(to: coordinator, with: .push)
    }

    func wantsToPresentCoordinator() {
        let coordinator = Flow1Coordinator(navigationController: navigationController)
        navigate(to: coordinator, with: .present())
    }

    func wantsToPopToRoot() {
        popToRootViewController(animated: true)
    }

    func wantsToDismiss() {
        dismiss()
    }
}
