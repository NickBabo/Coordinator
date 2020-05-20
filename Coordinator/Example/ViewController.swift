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

    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("push", for: .normal)
        button.addTarget(self, action: #selector(handlePush), for: .touchUpInside)
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

    override func viewDidLoad() {
        super.viewDidLoad()
        buildInterface()
    }

    func buildInterface() {
        view.backgroundColor = .red

        view.addSubview(button)
        view.addSubview(dismissButton)

        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.widthAnchor.constraint(equalToConstant: 90).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true

        dismissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        dismissButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        dismissButton.widthAnchor.constraint(equalToConstant: 90).isActive = true
        dismissButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }

    @objc
    func handlePush() {
        delegate?.didPushButton()
    }

    @objc
    func handleDismiss() {
        delegate?.wantsToDismiss()
    }
}

protocol ViewControllerDelegate {
    func didPushButton()
    func wantsToDismiss()
}
