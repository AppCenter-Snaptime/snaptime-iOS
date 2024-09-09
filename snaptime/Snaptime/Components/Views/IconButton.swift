//
//  IconButton.swift
//  Snaptime
//
//  Created by Bowon Han on 7/5/24.
//

import UIKit
import SnapKit

final class IconButton: UIButton {
    private var imageName: String
    private var action: UIAction
    private var size: Int
    
    init(name: String, size: Int, action: UIAction) {
        self.imageName = name
        self.action = action
        self.size = size
        super.init(frame: .zero)
        self.setupStyles()
        self.addAction(action, for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStyles() {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .black
        let imageConfig = UIImage.SymbolConfiguration(pointSize: CGFloat(size), weight: .light)
        let setImage = UIImage(systemName: imageName, withConfiguration: imageConfig)
        config.image = setImage
        
        self.configuration = config
    }
}

