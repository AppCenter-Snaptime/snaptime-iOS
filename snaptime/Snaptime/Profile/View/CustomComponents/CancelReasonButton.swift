//
//  CancelReasonButton.swift
//  Snaptime
//
//  Created by Bowon Han on 9/13/24.
//

import UIKit

final class CancelReasonButton: UIButton {
    private var reason: String
    private var number: Int
    
    init(reason: String, tag: Int) {
        self.number = tag
        self.reason = reason
        super.init(frame: .zero)
        
        setupStyles()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupStyles() {
        var config = UIButton.Configuration.plain()
        
        var titleAttr = AttributedString.init(reason)
        titleAttr.font = UIFont(name: SuitFont.medium, size: 14)
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .thin)
        
        let setImage = UIImage(systemName: "circle", withConfiguration: imageConfig)?.withTintColor(UIColor.init(hexCode: "d0d0d0"), renderingMode: .alwaysOriginal)
        
        config.attributedTitle = titleAttr
        config.imagePlacement = .leading
        config.imagePadding = 12
        config.image = setImage
        config.baseForegroundColor = .black
        config.baseBackgroundColor = .white
        self.configuration = config
        
        self.tag = number
    }
}
