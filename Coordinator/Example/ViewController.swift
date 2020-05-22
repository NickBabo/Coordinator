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

    private lazy var pushButton: UIButton = {
        let button = UIButton()
        button.setTitle("push", for: .normal)
        button.addTarget(self, action: #selector(handlePush), for: .touchUpInside)
        button.backgroundColor = .green
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var presentButton: UIButton = {
        let button = UIButton()
        button.setTitle("present", for: .normal)
        button.addTarget(self, action: #selector(handlePresent), for: .touchUpInside)
        button.backgroundColor = .green
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var coordinatorPushButton: UIButton = {
        let button = UIButton()
        button.setTitle("push coordinator", for: .normal)
        button.addTarget(self, action: #selector(handleCoordinatorPush), for: .touchUpInside)
        button.backgroundColor = .green
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var coordinatorPresentButton: UIButton = {
        let button = UIButton()
        button.setTitle("present coordinator", for: .normal)
        button.addTarget(self, action: #selector(handleCoordinatorPresent), for: .touchUpInside)
        button.backgroundColor = .green
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.setTitle("dismiss", for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        button.backgroundColor = .purple
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var popToRootButton: UIButton = {
        let button = UIButton()
        button.setTitle("pop to root", for: .normal)
        button.addTarget(self, action: #selector(handleRootPop), for: .touchUpInside)
        button.backgroundColor = .purple
        button.translatesAutoresizingMaskIntoConstraints = false
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

    override func viewDidLoad() {
        super.viewDidLoad()
        buildInterface()
        view.backgroundColor = .white
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
        stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true

        pushButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        presentButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        coordinatorPresentButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        coordinatorPushButton.heightAnchor.constraint(equalToConstant: 40).isActive = true

        dismissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        dismissButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        dismissButton.widthAnchor.constraint(equalToConstant: 90).isActive = true
        dismissButton.heightAnchor.constraint(equalToConstant: 40).isActive = true

        popToRootButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        popToRootButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        popToRootButton.widthAnchor.constraint(equalToConstant: 90).isActive = true
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
