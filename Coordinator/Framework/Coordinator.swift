import UIKit

typealias CoordinatorState = (navigationType: NavigationType, viewController: UIViewController)

class Coordinator: NSObject, CoordinatorType {

    var stateStack: [CoordinatorState] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
        navigationController.delegate = self
        navigationController.presentationController?.delegate = self
    }

    func start(with navigation: TransitionType) -> UIViewController {
        return navigationController
    }

    @discardableResult func navigate(to viewController: UIViewController,
                                     with navigationType: TransitionType) -> UIViewController? {

        switch navigationType {
            case .push:
                navigationController.pushViewController(viewController, animated: true)

            case .present(let replacingPreviousController, let completion):
                viewController.presentationController?.delegate = self

                if replacingPreviousController {
                    dismiss { [weak self] in
                        self?.present(viewController, completion: completion)
                    }
                } else {
                    guard navigationController.presentedViewController == nil else { return nil }
                    present(viewController, completion: completion)
                }

            case .root:
                navigationController.viewControllers = [viewController]
        }

        appendState(navigationType: navigationType, viewController: viewController)

        return viewController
    }

    private func present(_ viewController: UIViewController, completion: (() -> Void)?) {
        navigationController.present(viewController,
                                     animated: true,
                                     completion: completion)

    }

    @discardableResult func navigate(to coordinator: Coordinator,
                                     with navigationType: TransitionType) -> Coordinator {
//        coordinator.setPreviousStates(stateStack)

        appendState(navigationType: CoordinatorNavigationType.coordinator(coordinator,
                                                                          navigationType: navigationType),
                    viewController: coordinator.start(with: navigationType))

        return coordinator
    }

//    func setPreviousStates(_ states: [CoordinatorState]) {
//        self.stateStack = states
//    }

    private func appendState(navigationType: NavigationType, viewController: UIViewController) {
        stateStack.append((navigationType, viewController))
    }

    func dismiss(_ completion: (() -> Void)? = nil) {
        guard let presentedViewController = navigationController.presentedViewController else {
            completion?()
            return
        }
        presentedViewController.dismiss(animated: true, completion: completion)
        handleDismiss()
    }

//    func handleDismiss() {
//        if currentState(is: .present()) {
//            _ = stateStack.popLast()
//        } else if let currentState = currentState?.navigationType as? CoordinatorNavigationType,
//            case .coordinator(_, let navigationType) = currentState,
//            case .present = navigationType  {
//
//            _ = stateStack.popLast()
//        }
//    }

    func handleDismiss() {
        if currentState(is: .present()) || currentStateIsCoordinator(with: .present()) {
            _ = stateStack.popLast()
        }
    }

    private func currentState(is transitionType: TransitionType) -> Bool {
        if case transitionType = currentState?.navigationType as? TransitionType {
            return true
        }
        return false
    }

    private func currentStateIsCoordinator(with transitionType: TransitionType) -> Bool {
        if case .coordinator(_, let coordinatorTransition) = currentState?.navigationType as? CoordinatorNavigationType {
            return coordinatorTransition == transitionType
        }
        return false
    }
}
