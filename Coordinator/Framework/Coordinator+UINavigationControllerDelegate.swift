//
//  Coordinator+UINavigationControllerDelegate.swift
//  Coordinator
//
//  Created by nicholas.r.babo on 20/05/20.
//  Copyright © 2020 Nicholas.Babo. All rights reserved.
//

import UIKit

extension Coordinator: UINavigationControllerDelegate {

    public func navigationController(_ navigationController: UINavigationController,
                              didShow viewController: UIViewController,
                              animated: Bool) {
        guard viewController != currentState?.viewController else { return } // Guard viewController change is a Pop

        if let viewControllerIndex = indexInTheStack(of: viewController) { // Popped to a viewController on stack
            handlePop(until: viewControllerIndex)
        } else { // Popped to a viewController from a previous coordinator
            stateStack.removeAll()
            didPopTo?(viewController)
        }
    }

    func indexInTheStack(of viewController: UIViewController) -> Array<CoordinatorState>.Index? {
        return stateStack.dropLast().firstIndex(where: { state -> Bool in
            state.viewController == viewController
        })
    }
}
