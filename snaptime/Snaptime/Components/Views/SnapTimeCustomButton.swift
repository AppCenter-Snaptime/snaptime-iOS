//
//  SnapTimeCustomButton.swift
//  snaptime
//
//  Created by Bowon Han on 2/1/24.
//

import UIKit
import SnapKit

final class SnapTimeCustomButton: UIButton {
    private let customTitle: String
    private let buttonEnabled: Bool
    
    init(_ title: String, _ enabled: Bool = true) {
        self.customTitle = title
        self.buttonEnabled = enabled
        super.init(frame: .zero)
        self.setupStyles()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func setupStyles() {
        self.setTitle(customTitle, for: .normal)
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        self.layer.cornerRadius = 10
        self.isEnabled = buttonEnabled
        
        switch buttonEnabled {
        case true:
            self.backgroundColor = .snaptimeBlue
        case false:
            self.backgroundColor = .snaptimeGray
        }
    }
}

