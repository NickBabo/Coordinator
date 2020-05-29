//
//  PopHandler.swift
//  Coordinator
//
//  Created by nicholas.r.babo on 29/05/20.
//  Copyright © 2020 Nicholas.Babo. All rights reserved.
//

import UIKit

class PopHandler: NSObject, UINavigationControllerDelegate {

    weak var delegate: PopDelegate?

    public func navigationController(_ navigationController: UINavigationController,
                                     didShow viewController: UIViewController,
                                     animated: Bool) {
        // Guard viewController change is a Pop
        guard viewController != delegate?.currentState?.viewController else { return }
        delegate?.handlePop(to: viewController)
    }
}

protocol PopDelegate: AnyObject {
    var currentState: CoordinatorState? { get }
    func handlePop(to viewController: UIViewController)
}
