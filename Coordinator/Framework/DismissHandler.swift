//
//  DismissHandler.swift
//  Coordinator
//
//  Created by nicholas.r.babo on 29/05/20.
//  Copyright © 2020 Nicholas.Babo. All rights reserved.
//

import UIKit

class DismissHandler: NSObject, UIAdaptivePresentationControllerDelegate {

    weak var delegate: DismissDelegate?

    public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        delegate?.handleDismiss()
    }

}

protocol DismissDelegate: AnyObject {
    func handleDismiss()
}
