//
//  AuthTextField.swift
//  snaptime
//
//  Created by Bowon Han on 2/1/24.
//

import UIKit
import SnapKit

class AuthTextField : UITextField {
    private let customPlaceholder: String
    
    init(_ placeholder: String) {
        self.customPlaceholder = placeholder
        super.init(frame: .zero)
        self.setupStyles()
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStyles() {
        self.borderStyle = .roundedRect
        self.placeholder = customPlaceholder
    }
    
    private func setupConstraints() {
        self.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.width.equalTo(300)
        }
    }
}
