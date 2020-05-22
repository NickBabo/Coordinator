//
//  NavigationType.swift
//  Coordinator
//
//  Created by nicholas.r.babo on 19/05/20.
//  Copyright © 2020 Nicholas.Babo. All rights reserved.
//

import Foundation

public protocol NavigationType { }

public enum TransitionType: NavigationType {
    case push
    case present(onTopOfPreviousController: Bool = false, _ completion: (() -> Void)? = nil)
    case root
}

public enum CoordinatorNavigationType: NavigationType {
    case coordinator(Coordinator, navigationType: TransitionType)
}
