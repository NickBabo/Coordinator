//
//  StateManager.swift
//  Coordinator
//
//  Created by nicholas.r.babo on 29/05/20.
//  Copyright © 2020 Nicholas.Babo. All rights reserved.
//

import UIKit

typealias CoordinatorState = (navigationType: NavigationType, viewController: UIViewController)

protocol StateManagerDelegate: AnyObject {
    func didEndCoordinator(poppedTo viewController: UIViewController?)
}

protocol StateManagerType {
    var currentState: CoordinatorState? { get }
    func didEndChildCoordinator(poppedTo viewController: UIViewController?)
}

class StateManager: NSObject, StateManagerType {

    weak var delegate: StateManagerDelegate?

    var stateStack: [CoordinatorState] = [] {
        didSet {
            print(makeMap())
            if stateStack.isEmpty { delegate?.didEndCoordinator(poppedTo: nil) }
        }
    }

    var currentState: CoordinatorState? {
        return stateStack.last
    }

    func append(_ viewController: UIViewController, via navigationType: TransitionType) {
        stateStack.append((navigationType, viewController))

        if case .present = navigationType, let navigationController = viewController as? UINavigationController {
            navigationController.viewControllers.forEach { append($0, via: .push) }
        }
    }

    func append(_ coordinator: Coordinator, via navigationType: TransitionType) {
        stateStack.append((CoordinatorNavigationType.coordinator(coordinator, navigationType: navigationType),
                           coordinator.start(with: navigationType)))
    }

    func didEndChildCoordinator(poppedTo viewController: UIViewController?) {
        if let viewController = viewController {
            handlePop(to: viewController)
        } else {
            if let index = stateStack.lastIndex(where: { state -> Bool in
                if case .coordinator = state.navigationType as? CoordinatorNavigationType {
                    return true
                } else {
                    return false
                }
            }) {
                handleRemoval(until: stateStack.index(before: index))
            }
        }
    }

    func handleRemoval(until index: Array<CoordinatorState>.Index) {
        let k = (stateStack.count - 1) - index
        stateStack = stateStack.dropLast(k)
    }

    private func indexInTheStack(of viewController: UIViewController) -> Array<CoordinatorState>.Index? {
        return stateStack.dropLast().firstIndex(where: { state -> Bool in
            state.viewController == viewController
        })
    }

    private func indexOfLastState(with transitionType: TransitionType) -> Array<CoordinatorState>.Index? {
        stateStack.lastIndex(where: { state -> Bool in
            if case .present = (state.navigationType as? TransitionType) {
                return true
            }
            return false
        })
    }

}

extension StateManager: DismissDelegate {
    func handleDismiss(){
        if let lastPresentedIndex = indexOfLastState(with: .present()) {
            handleRemoval(until: stateStack.index(before: lastPresentedIndex))
        }
    }
}

extension StateManager: PopDelegate {
    func handlePop(to viewController: UIViewController) {
        if let viewControllerIndex = indexInTheStack(of: viewController) {
            handleRemoval(until: viewControllerIndex)
        } else {
            delegate?.didEndCoordinator(poppedTo: viewController)
            stateStack.removeAll()
        }
    }
}

// MARK:  Map
extension StateManager {
    func makeMap() -> String {
        var map = ""
        stateStack.forEach {
            map.append("\($0.navigationType): \($0.viewController.title ?? $0.viewController.description) -> ")
        }
        if !stateStack.isEmpty {
            map.removeLast(4)
        }
        return map
    }
}
