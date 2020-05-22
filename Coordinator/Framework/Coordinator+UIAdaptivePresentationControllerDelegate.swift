//
//  Coordinator+UIAdaptivePresentationControllerDelegate.swift
//  Coordinator
//
//  Created by nicholas.r.babo on 20/05/20.
//  Copyright © 2020 Nicholas.Babo. All rights reserved.
//

import UIKit

extension Coordinator: UIAdaptivePresentationControllerDelegate {
    public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        handleDismiss()
    }
}
