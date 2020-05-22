import UIKit

typealias CoordinatorState = (navigationType: NavigationType, viewController: UIViewController)

class Coordinator: NSObject, CoordinatorType {

    var didEndCoordinator: (() -> Void)?

    var stateStack: [CoordinatorState] = [] {
        didSet {
            print("\(self.description) - \(stateStack.count)")
            if stateStack.isEmpty { didEndCoordinator?() }
        }
    }

    var navigationController: UINavigationController
    var presentedCoordinatorSubNavigationController = UINavigationController()

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
                                     with navigationType: TransitionType) -> UIViewController {

        switch navigationType {
            case .push:
                push(viewController)

            case .present(let replacingPreviousController, let completion):
                viewController.presentationController?.delegate = self

                if replacingPreviousController {
                    dismiss { [weak self] in
                        self?.present(viewController, completion: completion)
                    }
                } else {
                    guard navigationController.presentedViewController == nil else { return viewController }
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

    private func push(_ viewController: UIViewController) {
        if let subNavigation = stateStack.last?.viewController.navigationController,
            subNavigation != self.navigationController {
            subNavigation.delegate = self
            subNavigation.pushViewController(viewController, animated: true)
        } else {
            navigationController.delegate = self
            navigationController.pushViewController(viewController, animated: true)
        }
    }

    @discardableResult func navigate(to coordinator: Coordinator,
                                     with navigationType: TransitionType) -> Coordinator? {
        coordinator.didEndCoordinator = { [weak self] in
            self?.handleCoordinatorEnd(coordinator)
        }

        appendState(navigationType: CoordinatorNavigationType.coordinator(coordinator,
                                                                          navigationType: navigationType),
                    viewController: coordinator.start(with: navigationType))

        return coordinator
    }

    private func appendState(navigationType: NavigationType, viewController: UIViewController) {
        stateStack.append((navigationType, viewController))

        if case .present = navigationType as? TransitionType, let navigationController = viewController as? UINavigationController {
            navigationController.viewControllers.forEach { appendState(navigationType: TransitionType.push,
                                                                       viewController: $0) }
        }
    }

    func dismiss(_ completion: (() -> Void)? = nil) {
        guard let presentedViewController = navigationController.presentedViewController else {
            completion?()
            return
        }
        presentedViewController.dismiss(animated: true, completion: completion)
        handleDismiss()
    }

    func handleDismiss() {
        if let lastPresentedIndex = stateStack.lastIndex(where: { state -> Bool in
            if case .present = (state.navigationType as? TransitionType) {
                return true
            } else {
                return false
            }
        }) {
            handlePop(until: stateStack.index(before: lastPresentedIndex))
        }


//        if currentState(is: .present()) {
//            _ = stateStack.popLast()
//        } else if case .present = stateStack.first?.navigationType as? TransitionType {
//            stateStack.removeAll()
//        }
    }

    func handleCoordinatorEnd(_ coordinator: Coordinator) {
        let coordinatorStateIndex = stateStack.firstIndex { state -> Bool in
            if case .coordinator(let coord, _) = state.navigationType as? CoordinatorNavigationType {
                return coord == coordinator
            }
            return false
        }

        guard let index = coordinatorStateIndex else { return }
        handlePop(until: stateStack.index(before: index))
    }


    func handlePop(until index: Array<CoordinatorState>.Index) {
        let k = (stateStack.count - 1) - index
        stateStack = stateStack.dropLast(k)
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

    func popToRootViewController(animated: Bool = true) {
        stateStack.last?.viewController.navigationController?.popToRootViewController(animated: animated)
    }
}
