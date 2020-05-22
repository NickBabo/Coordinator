//
//  Flow1Coordinator.swift
//  Coordinator
//
//  Created by nicholas.r.babo on 20/05/20.
//  Copyright © 2020 Nicholas.Babo. All rights reserved.
//

import UIKit

final class Flow1Coordinator: Coordinator {

    private var canDismiss: Bool = false
    private var canPopToRoot: Bool = false

    override func start(with navigation: TransitionType) -> UIViewController {
        switch navigation {
        case .present:
            canDismiss = true
            let viewController = Flow1ViewController(canDismiss: canDismiss, canPopToRoot: canPopToRoot)
            viewController.delegate = self
            let navigationcontroller = UINavigationController()
            navigationcontroller.viewControllers = [viewController]
            return navigate(to: navigationcontroller, with: navigation)
        case .push:
            canPopToRoot = true
            let viewController = Flow1ViewController(canDismiss: canDismiss, canPopToRoot: canPopToRoot)
            viewController.delegate = self
            return navigate(to: viewController, with: navigation)
        default:
            let viewController = Flow1ViewController(canDismiss: canDismiss, canPopToRoot: canPopToRoot)
            viewController.delegate = self
            return viewController
        }
    }
}

extension Flow1Coordinator: ViewControllerDelegate {
    func wantsToPush() {
        canPopToRoot = true
        let viewController = ViewController(canDismiss: canDismiss, canPopToRoot: canPopToRoot)
        viewController.delegate = self
        navigate(to: viewController, with: .push)
    }

    func wantsToPresent() {
        canDismiss = true
        canPopToRoot = false
        let viewController = ViewController(canDismiss: canDismiss, canPopToRoot: canPopToRoot)
        viewController.delegate = self
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
        canPopToRoot = false
        popToRootViewController(animated: true)
    }

    func wantsToDismiss() {
        canDismiss = false
        dismiss()
    }
}
