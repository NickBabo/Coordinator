//
//  NavigationType.swift
//  Coordinator
//
//  Created by nicholas.r.babo on 19/05/20.
//  Copyright © 2020 Nicholas.Babo. All rights reserved.
//

import Foundation

protocol NavigationType { }

enum TransitionType: NavigationType {
    case push
    case present(onTopOfPreviousController: Bool = false, _ completion: (() -> Void)? = nil)
    case root
}

enum CoordinatorNavigationType: NavigationType {
    case coordinator(Coordinator, navigationType: TransitionType)
}

extension TransitionType: Equatable {
    static func == (lhs: TransitionType, rhs: TransitionType) -> Bool {
        switch (lhs, rhs) {
            case (.push, .push): return true
            case (.present, .present): return true
            case (.root, .root): return true
            default: return false
        }
    }
}
