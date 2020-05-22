import UIKit

final class HomeCoordinator: Coordinator {

    private var canDismiss: Bool = false
    private var canPopToRoot: Bool = false

    override func start(with navigation: TransitionType) -> UIViewController {
        let viewController = ViewController(canDismiss: canDismiss, canPopToRoot: canPopToRoot)
        viewController.delegate = self
        navigate(to: viewController, with: .root)

        return super.start(with: navigation)
    }
}

extension HomeCoordinator: ViewControllerDelegate {
    func wantsToPush() {
        canPopToRoot = true
        let viewController = ViewController(canDismiss: canDismiss, canPopToRoot: canPopToRoot)
        viewController.delegate = self
        navigate(to: viewController, with: .push)
    }

    func wantsToPresent() {
        canDismiss = true
        canPopToRoot = false
        let viewController = ViewController(canDismiss: canDismiss, canPopToRoot: canPopToRoot)
        viewController.delegate = self
        navigate(to: viewController, with: .present())
    }

    func wantsToPushCoordinator() {
        let coordinator = Flow1Coordinator(navigationController: navigationController)
        navigate(to: coordinator, with: .push)
    }

    func wantsToPresentCoordinator() {
        let coordinator = Flow1Coordinator(navigationController: navigationController)
        navigate(to: coordinator, with: .present())
    }

    func wantsToPopToRoot() {
        canPopToRoot = false
        popToRootViewController(animated: true)
    }

    func wantsToDismiss() {
        canDismiss = false
        dismiss()
    }
}
