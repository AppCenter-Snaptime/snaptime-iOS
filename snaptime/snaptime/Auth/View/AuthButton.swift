//
//  AuthButton.swift
//  snaptime
//
//  Created by Bowon Han on 2/1/24.
//

import UIKit
import SnapKit

class AuthButton : UIButton {
    private let customTitle: String
    
    init(_ title: String) {
        self.customTitle = title
        super.init(frame: .zero)
        self.setupStyles()
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStyles() {
        self.setTitle(customTitle, for: .normal)
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        self.layer.cornerRadius = 10
        self.backgroundColor = .lightGray
    }
    
    private func setupConstraints() {
        self.snp.makeConstraints {
            $0.width.equalTo(300)
            $0.height.equalTo(50)
        }
    }
}
