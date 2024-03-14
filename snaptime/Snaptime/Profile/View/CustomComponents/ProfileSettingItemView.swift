//
//  ProfileSettingItemView.swift
//  Snaptime
//
//  Created by Bowon Han on 3/9/24.
//

import UIKit
import SnapKit

final class ProfileSettingItemView: UIView {
    private let customDescription: String
    private let customIconName: String
    
    init(iconName: String, description: String) {
        self.customDescription = description
        self.customIconName = iconName
        super.init(frame: .zero)
        self.setupStyles()
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let iconButton = UIButton()
    private let settingDescriptionButton = UIButton()
    
    private func setupStyles() {
        var iconConfig = UIButton.Configuration.filled()
        iconConfig.baseBackgroundColor = .white
        iconConfig.baseForegroundColor = .black
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .light)
        let setImage = UIImage(systemName: customIconName, withConfiguration: imageConfig)
        iconConfig.image = setImage
        
        iconButton.configuration = iconConfig
        
        
        var descriptionConfig = UIButton.Configuration.filled()
        descriptionConfig.baseBackgroundColor = .white
        descriptionConfig.baseForegroundColor = .black

        var titleAttr = AttributedString.init(customDescription)
        titleAttr.font = .systemFont(ofSize: 15.0, weight: .medium)
        
        descriptionConfig.attributedTitle = titleAttr
        
        settingDescriptionButton.configuration = descriptionConfig
    }
    
    private func setupConstraints() {
        [iconButton, 
         settingDescriptionButton].forEach {
            addSubview($0)
        }
        
        iconButton.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.top.bottom.equalToSuperview()
            $0.width.height.equalTo(40)
        }
        
        settingDescriptionButton.snp.makeConstraints {
            $0.left.equalTo(iconButton.snp.right).offset(5)
            $0.top.bottom.equalTo(iconButton)
            $0.height.equalTo(40)
        }
    }
}
