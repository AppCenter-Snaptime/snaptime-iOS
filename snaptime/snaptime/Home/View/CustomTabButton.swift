//
//  CustomTabButton.swift
//  snaptime
//
//  Created by Bowon Han on 2/6/24.
//

import UIKit

class CustomTabButton : UIButton {
    private let customTitle: String
    private let customImageName: String
    
    init(_ title: String, _ imageName: String) {
        self.customTitle = title
        self.customImageName = imageName
        super.init(frame: .zero)
        self.setupStyles()
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func setupStyles() {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .white
        config.baseForegroundColor = .black
        config.imagePlacement = .top
        config.image = UIImage(systemName: customImageName)

        var titleAttr = AttributedString.init(customTitle)
        titleAttr.font = .systemFont(ofSize: 10.0, weight: .light)
        config.attributedTitle = titleAttr
        config.imagePadding = 5
        
        self.configuration = config
    }
    
    private func setupConstraints() {
        self.snp.makeConstraints {
            $0.height.equalTo(40)
        }
    }
}
