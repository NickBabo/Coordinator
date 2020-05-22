import UIKit

final class HomeCoordinator: Coordinator {

    override func start(with navigation: TransitionType) -> UIViewController {
        let viewController = ViewController()
        viewController.delegate = self
        navigate(to: viewController, with: .root)

        return super.start(with: navigation)
    }
}

extension HomeCoordinator: ViewControllerDelegate {
    func wantsToPush() {
        let viewController = ViewController()
        viewController.delegate = self
        viewController.view.backgroundColor = .blue
        navigate(to: viewController, with: .push)
    }

    func wantsToPresent() {
        let viewController = ViewController()
        viewController.delegate = self
        viewController.view.backgroundColor = .green
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
        popToRootViewController(animated: true)
    }

    func wantsToDismiss() {
        dismiss()
    }
}
