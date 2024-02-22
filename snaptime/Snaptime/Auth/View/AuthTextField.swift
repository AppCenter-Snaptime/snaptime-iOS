//
//  AuthTextField.swift
//  snaptime
//
//  Created by Bowon Han on 2/1/24.
//

import UIKit
import SnapKit

final class AuthTextField : UITextField {
    private let customPlaceholder: String
    
    init(_ placeholder: String) {
        self.customPlaceholder = placeholder
        super.init(frame: .zero)
        self.setupStyles()
        self.setupConstraints()
//        self.addTarget(self, action: #selector(editingDidBegin), for: .editingDidEnd)
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
    }
    
    private func setupConstraints() {
        self.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.width.equalTo(300)
        }
        
        addSubview(underLine)
        
        underLine.snp.makeConstraints {
            $0.top.equalTo(self.snp.bottom)
            $0.left.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
}

extension AuthTextField {
    @objc func editingDidBegin() {
        underLine.backgroundColor = .snaptimeBlue
    }
}
