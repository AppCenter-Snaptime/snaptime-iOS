//
//  TagButton.swift
//  Snaptime
//
//  Created by 이대현 on 7/31/24.
//

import UIKit
import SnapKit

final class TagButton: UIButton {
    private var tagName: String
    private var action: UIAction?
    
    init(tagName: String, action: UIAction? = nil) {
        self.tagName = tagName
        self.action = action
        super.init(frame: .zero)
        self.setupStyles()
        if let action = action {
            self.addAction(action, for: .touchUpInside)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStyles() {
        var config = UIButton.Configuration.borderedTinted()
        
        var titleAttr = AttributedString.init(tagName)
        titleAttr.font = .systemFont(ofSize: 14, weight: .regular)
        
        config.attributedTitle = titleAttr
        config.imagePlacement = .leading
        config.imagePadding = 8
        config.image = UIImage(systemName: "person")
        config.cornerStyle = .large
        config.baseForegroundColor = .snaptimeBlue
        config.baseBackgroundColor = .white
        config.background.strokeWidth = 1
        config.background.strokeColor = .snaptimeGray
        
        self.configuration = config
    }
}
