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
        let navigationcontroller = UINavigationController()
        navigationcontroller.viewControllers = [viewController]
        return navigate(to: navigationcontroller, with: navigation)
    }
}

extension Flow1Coordinator: ViewControllerDelegate {
    func didPushButton() {
        let viewController = ViewController()
        viewController.view.backgroundColor = .green
        navigate(to: viewController, with: .push)
    }

    func wantsToDismiss() {
        dismiss()
    }
}
