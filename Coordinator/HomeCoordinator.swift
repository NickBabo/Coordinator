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
    func didPushButton() {
        let viewController = ViewController()
        viewController.delegate = self
        viewController.view.backgroundColor = .blue
//        navigate(to: viewController, with: .present(onTopOfPreviousController: true))
        navigate(to: viewController, with: .present())
        print(stateStack)
    }

    func wantsToDismiss() {
//        navigationController.popToRootViewController(animated: true)
        dismiss()
    }
}
