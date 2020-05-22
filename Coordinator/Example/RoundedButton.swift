//
//  RoundedButton.swift
//  Coordinator
//
//  Created by nicholas.r.babo on 22/05/20.
//  Copyright © 2020 Nicholas.Babo. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        roundButton()
        backgroundColor = UIColor(red: 0.77, green: 0.51, blue: 1.00, alpha: 1.00)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }

    private func roundButton() {
        layer.cornerRadius = 8
        clipsToBounds = true
    }
}
