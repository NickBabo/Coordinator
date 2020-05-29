import UIKit

protocol ParentCoordinatorType: AnyObject {
    func notifyEnd(poppedTo viewController: UIViewController?)
}

public class Coordinator: NSObject, CoordinatorType {

    var didEndCoordinatorCompletion: (() -> Void)?

    var dismissHandler: DismissHandler = DismissHandler()
    var popHandler: PopHandler = PopHandler()
    let stateManager: StateManager = StateManager()

    weak var parentCoordinator: ParentCoordinatorType?

    var navigationController: UINavigationController

    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()

        dismissHandler.delegate = stateManager
        popHandler.delegate = stateManager

        navigationController.delegate = popHandler
        navigationController.presentationController?.delegate = dismissHandler

        stateManager.delegate = self
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
                viewController.presentationController?.delegate = dismissHandler

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

        stateManager.append(viewController, via: navigationType)

        return viewController
    }

    private func present(_ viewController: UIViewController, completion: (() -> Void)?) {
        if let navigationController = viewController as? UINavigationController {
            navigationController.delegate = popHandler
        }
        navigationController.present(viewController,
                                     animated: true,
                                     completion: completion)

    }

    private func push(_ viewController: UIViewController) {
        if let subNavigation = stateManager.currentState?.viewController.navigationController,
            subNavigation != self.navigationController {
            subNavigation.delegate = self.popHandler
            subNavigation.pushViewController(viewController, animated: true)
        } else {
            navigationController.delegate = popHandler
            navigationController.pushViewController(viewController, animated: true)
        }
    }

    @discardableResult func navigate(to coordinator: Coordinator,
                                     with navigationType: TransitionType) -> Coordinator? {
        
        coordinator.parentCoordinator = self
        navigationController.delegate = coordinator.popHandler

        stateManager.append(coordinator, via: navigationType)

        return coordinator
    }

    public func dismiss(_ completion: (() -> Void)? = nil) {
        guard let presentedViewController = navigationController.presentedViewController else {
            completion?()
            return
        }
        presentedViewController.dismiss(animated: true, completion: completion)
        stateManager.handleDismiss()
    }

    func popToRootViewController(animated: Bool = true) {
        stateManager.currentState?.viewController.navigationController?.popToRootViewController(animated: animated)
    }
}

extension Coordinator: ParentCoordinatorType {
    func notifyEnd(poppedTo viewController: UIViewController?) {
        stateManager.didEndChildCoordinator(poppedTo: viewController)
        navigationController.delegate = popHandler

        if let viewController = viewController {
            navigationController.popToViewController(viewController, animated: true)
        }
    }
}

extension Coordinator: StateManagerDelegate {
    func didEndCoordinator(poppedTo viewController: UIViewController?) {
        parentCoordinator?.notifyEnd(poppedTo: viewController)
    }
}
