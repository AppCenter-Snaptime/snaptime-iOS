//
//  ProfileTabButton.swift
//  Snaptime
//
//  Created by Bowon Han on 2/21/24.
//

import UIKit
import SnapKit

final class ProfileTabButton : UIButton {
    private let tabTitle : String
    
    private let lineView = UIView()
    
    init(_ title: String) {
        self.tabTitle = title
        super.init(frame: .zero)
        self.setupStyles()
        self.setupLayout()
        self.setupConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStyles() {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .white
        config.baseForegroundColor = .black

        var titleAttr = AttributedString.init(tabTitle)
        titleAttr.font = .systemFont(ofSize: 15.0, weight: .light)
        
        config.attributedTitle = titleAttr
        
        self.configuration = config
        
        lineView.backgroundColor = .black
    }
    
    private func setupLayout() {
        addSubview(lineView)
    }
    
    private func setupConstrains() {
        lineView.snp.makeConstraints {
            $0.bottom.equalTo(self.snp.bottom)
            $0.centerX.equalTo(self)
            $0.height.equalTo(2)
            $0.width.equalTo(57)
        }
    }
}
