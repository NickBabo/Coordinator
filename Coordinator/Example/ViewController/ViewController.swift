//
//  ViewController.swift
//  Coordinator
//
//  Created by nicholas.r.babo on 19/05/20.
//  Copyright © 2020 Nicholas.Babo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var delegate: ViewControllerDelegate?

    private lazy var pushButton: RoundedButton = {
        let button = RoundedButton()
        button.setTitle("push", for: .normal)
        button.addTarget(self, action: #selector(handlePush), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var presentButton: RoundedButton = {
        let button = RoundedButton()
        button.setTitle("present", for: .normal)
        button.addTarget(self, action: #selector(handlePresent), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var coordinatorPushButton: RoundedButton = {
        let button = RoundedButton()
        button.setTitle("push coordinator", for: .normal)
        button.addTarget(self, action: #selector(handleCoordinatorPush), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var coordinatorPresentButton: RoundedButton = {
        let button = RoundedButton()
        button.setTitle("present coordinator", for: .normal)
        button.addTarget(self, action: #selector(handleCoordinatorPresent), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var dismissButton: RoundedButton = {
        let button = RoundedButton()
        button.setTitle("dismiss", for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = !canDismiss
        button.sizeToFit()
        return button
    }()

    private lazy var popToRootButton: RoundedButton = {
        let button = RoundedButton()
        button.setTitle("pop to root", for: .normal)
        button.addTarget(self, action: #selector(handleRootPop), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = !canPopToRoot
        button.sizeToFit()
        return button
    }()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.spacing = 8
        return stack
    }()

    private let canDismiss: Bool
    private let canPopToRoot: Bool

    init(canDismiss: Bool, canPopToRoot: Bool) {
        self.canPopToRoot = canPopToRoot
        self.canDismiss = canDismiss
        super.init(nibName: nil, bundle: nil)
        title = "ViewController"
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        buildInterface()
        view.backgroundColor = UIColor(red: 1.00, green: 0.95, blue: 0.69, alpha: 1.00)
    }

    func buildInterface() {
        stackView.addArrangedSubview(pushButton)
        stackView.addArrangedSubview(presentButton)
        stackView.addArrangedSubview(coordinatorPushButton)
        stackView.addArrangedSubview(coordinatorPresentButton)

        view.addSubview(stackView)
        view.addSubview(dismissButton)
        view.addSubview(popToRootButton)

        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true

        pushButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        presentButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        coordinatorPresentButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        coordinatorPushButton.heightAnchor.constraint(equalToConstant: 40).isActive = true

        dismissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        dismissButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        dismissButton.heightAnchor.constraint(equalToConstant: 40).isActive = true

        popToRootButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        popToRootButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        popToRootButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }

    @objc
    func handlePush() {
        delegate?.wantsToPush()
    }

    @objc
    func handlePresent() {
        delegate?.wantsToPresent()
    }

    @objc
    func handleCoordinatorPush() {
        delegate?.wantsToPushCoordinator()
    }

    @objc
    func handleCoordinatorPresent() {
        delegate?.wantsToPresentCoordinator()
    }

    @objc
    func handleDismiss() {
        delegate?.wantsToDismiss()
    }

    @objc
    func handleRootPop() {
        delegate?.wantsToPopToRoot()
    }
}

protocol ViewControllerDelegate {
    func wantsToPush()
    func wantsToPresent()
    func wantsToPushCoordinator()
    func wantsToPresentCoordinator()
    func wantsToDismiss()
    func wantsToPopToRoot()
}
