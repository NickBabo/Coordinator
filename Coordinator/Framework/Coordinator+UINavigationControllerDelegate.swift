//
//  Coordinator+UINavigationControllerDelegate.swift
//  Coordinator
//
//  Created by nicholas.r.babo on 20/05/20.
//  Copyright © 2020 Nicholas.Babo. All rights reserved.
//

import UIKit

extension Coordinator: UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController,
                              didShow viewController: UIViewController,
                              animated: Bool) {
        if let existingIndex = stateStack.dropLast().firstIndex(where: {
            $0.viewController == viewController
        }) {
            handlePop(until: existingIndex)
        }
    }
}
