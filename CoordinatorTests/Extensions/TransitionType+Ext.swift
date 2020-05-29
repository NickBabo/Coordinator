//
//  TransitionType+Ext.swift
//  CoordinatorTests
//
//  Created by nicholas.r.babo on 29/05/20.
//  Copyright © 2020 Nicholas.Babo. All rights reserved.
//

import Foundation
@testable import Coordinator

extension TransitionType: Equatable {
    public static func == (lhs: TransitionType, rhs: TransitionType) -> Bool {
        switch (lhs, rhs) {
            case (.push, .push): return true
            case (.root, .root): return true
            case (.present(let leftParameter, _), .present(let rightParameter, _)):
                return leftParameter == rightParameter
            default: return false
        }
    }


}
