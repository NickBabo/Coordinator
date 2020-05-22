import UIKit

typealias CoordinatorState = (navigationType: NavigationType, viewController: UIViewController)

public class Coordinator: NSObject, CoordinatorType {

    var didEndCoordinator: (() -> Void)?
    var didPopTo: ((UIViewController) -> Void)?

    var stateStack: [CoordinatorState] = [] {
        didSet {
            print(makeMap())
            if stateStack.isEmpty { didEndCoordinator?() }
        }
    }

    var navigationController: UINavigationController

    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
        navigationController.delegate = self
        navigationController.presentationController?.delegate = self
    }

    public func start(with navigation: TransitionType) -> UIViewController {
        return navigationController
    }

    @discardableResult public func navigate(to viewController: UIViewController,
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

        coordinator.didPopTo = { [weak self] viewController in
            self?.handlePop(to: viewController)
        }

        navigationController.delegate = coordinator

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
        if let lastPresentedIndex = indexOfLastState(with: .present()) {
            handlePop(until: stateStack.index(before: lastPresentedIndex))
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
        navigationController.delegate = self
        handlePop(until: stateStack.index(before: index))
    }

    func handlePop(to viewController: UIViewController) {
        if let viewControllerIndex = indexInTheStack(of: viewController) {
            handlePop(until: viewControllerIndex)
        }
    }

    func handlePop(until index: Array<CoordinatorState>.Index) {
        let k = (stateStack.count - 1) - index
        stateStack = stateStack.dropLast(k)
    }

    private func indexOfLastState(with transitionType: TransitionType) -> Array<CoordinatorState>.Index? {
        stateStack.lastIndex(where: { state -> Bool in
            if case .present = (state.navigationType as? TransitionType) {
                return true
            }
            return false
        })
    }

    func popToRootViewController(animated: Bool = true) {
        stateStack.last?.viewController.navigationController?.popToRootViewController(animated: animated)
    }

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

