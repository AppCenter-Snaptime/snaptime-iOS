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
    
//    var lineColorToggle: Bool?

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
    
    private let underLine : UIView = {
        let view = UIView()
        view.backgroundColor = .snaptimeGray
        
        return view
    }()
    
    private func setupStyles() {
        self.borderStyle = .none
        self.placeholder = customPlaceholder
        
        if secureToggle == true {
            self.isSecureTextEntry = true
        }
    }
    
    func setLineColorTrue() {
        underLine.backgroundColor = .init(hexCode: "3B6DFF")
    }
    
    func setLineColorFalse() {
        underLine.backgroundColor = .snaptimeGray
    }
    
    private func setupConstraints() {
        self.snp.makeConstraints {
            $0.height.equalTo(40)
        }
        
        addSubview(underLine)
        
        underLine.snp.makeConstraints {
            $0.top.equalTo(self.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
}
