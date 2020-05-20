import UIKit

typealias CoordinatorState = (navigationType: NavigationType, viewController: UIViewController)

class Coordinator: NSObject, CoordinatorType {

    var didEndCoordinator: (() -> Void)?

    var stateStack: [CoordinatorState] = [] {
        didSet {
            if stateStack.isEmpty { didEndCoordinator?() }
        }
    }

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
                                     with navigationType: TransitionType) -> UIViewController {

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

    func setPreviousStates(_ states: [CoordinatorState]) {
        self.stateStack = states
    }

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

    func handleCoordinatorEnd(_ coordinator: Coordinator) {
        let coordinatorStateIndex = stateStack.firstIndex { state -> Bool in
            if case .coordinator(let coord, _) = state.navigationType as? CoordinatorNavigationType {
                return coord == coordinator
            }
            return false
        }

        guard let index = coordinatorStateIndex else { return }
        handlePop(until: index)
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

//    override var description: String {
//        return formatDescription()
//    }
//
//    private func format(_ state: CoordinatorState) -> String {
//        switch state.navigationType {
//            case TransitionType.push:
//                return "Push - \(state.viewController.description)"
//            case TransitionType.present:
//                return "Present - \(state.viewController.description)"
//            case TransitionType.root:
//                return "Root - \(state.viewController.description)"
//            case CoordinatorNavigationType.coordinator(let coordinator, let transitionType):
//                return "Coordinator - \(coordinator.description) - \(transitionType)"
//            default:
//                return "unknown state"
//        }
//    }

//    private func formatDescription() -> String {
//        let stackDescription: [String] = stateStack.compactMap { state -> String in
//            "\(format(state))"
//        }
//        return "\n -- State Stack -- \n \(stackDescription)"
//    }
}
