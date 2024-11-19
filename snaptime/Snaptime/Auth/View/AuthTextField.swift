//
//  AuthTextField.swift
//  snaptime
//
//  Created by Bowon Han on 2/1/24.
//

import UIKit
import SnapKit

final class AuthTextField: UITextField {
    private let customPlaceholder: String
    private let secureToggle: Bool
    
    init(_ placeholder: String, secureToggle: Bool = false) {
        self.customPlaceholder = placeholder
        self.secureToggle = secureToggle
        super.init(frame: .zero)
        self.setupStyles()
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupStyles() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.init(hexCode: "d0d0d0").cgColor
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        self.leftViewMode = .always
        self.font = UIFont(name: SuitFont.medium, size: 14)
        self.attributedPlaceholder = NSAttributedString(string: customPlaceholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(hexCode: "929292")])
        
        if secureToggle == true {
            self.isSecureTextEntry = true
        }
    }
    
    private func setupConstraints() {
        self.snp.makeConstraints {
            $0.height.equalTo(49)
        }
    }
}
