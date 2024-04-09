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
    var tabButtonAction : (() -> ())?
    
    init(_ title: String) {
        self.customTitle = title
        super.init(frame: .zero)
        self.setupStyles()
        self.addTarget(self, action: #selector(tabButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tabButton() {
        tabButtonAction?()  
    }
        
    private func setupStyles() {
        self.setTitle(customTitle, for: .normal)
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        self.layer.cornerRadius = 10
        self.backgroundColor = .snaptimeBlue
        self.isEnabled = false
    }
}

