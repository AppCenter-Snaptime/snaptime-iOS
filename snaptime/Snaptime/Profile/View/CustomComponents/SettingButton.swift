//
//  SettingButton.swift
//  Snaptime
//
//  Created by Bowon Han on 11/20/24.
//

import UIKit
import SnapKit

final class SettingButton: UIButton {
    private var title: String
    private var imageName: String
    
    init(title: String, imageName: String) {
        self.title = title
        self.imageName = imageName
        super.init(frame: .zero)
        
        setupStyles()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupStyles() {
        var config = UIButton.Configuration.plain()
        var titleAttr = AttributedString.init(self.title)
        titleAttr.font = UIFont(name: SuitFont.medium, size: 14)
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .light)
        let setImage = UIImage(systemName: self.imageName, withConfiguration: imageConfig)
        
        config.baseBackgroundColor = .white
        config.baseForegroundColor = .black
        config.image = setImage
        config.attributedTitle = titleAttr
        config.imagePlacement = .leading
        config.imagePadding = 10
        
        self.configuration = config
    }
}
