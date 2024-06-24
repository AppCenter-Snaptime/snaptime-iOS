//
//  SettingView.swift
//  Snaptime
//
//  Created by Bowon Han on 3/9/24.
//

import UIKit
import SnapKit

final class ProfileSettingView: UIView {    
    private let firstTitle: String
    private let secondTitle: String
    private let firstAction: UIAction
    private let secondAction: UIAction
    
    init(first: String, second: String, firstAction: UIAction, secondAction: UIAction) {
        self.firstTitle = first
        self.secondTitle = second
        self.firstAction = firstAction
        self.secondAction = secondAction
        super.init(frame: .zero)
        self.setupLayouts()
        self.setupStyles()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let containerView = UIView()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 5
        
        return stackView
    }()
    
    private let profileSettingItem1 = UIButton()
    private let profileSettingItem2 = UIButton()
    
    private func setupStyles() {
        var descriptionConfig = UIButton.Configuration.filled()
        descriptionConfig.baseBackgroundColor = .white
        descriptionConfig.baseForegroundColor = .black
        descriptionConfig.imagePadding = 10
        descriptionConfig.imagePlacement = .leading

        var titleAttr = AttributedString.init(self.firstTitle)
        titleAttr.font = .systemFont(ofSize: 15.0, weight: .medium)
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .light)
        let setImage = UIImage(systemName: "bell", withConfiguration: imageConfig)
        
        descriptionConfig.image = setImage
        descriptionConfig.attributedTitle = titleAttr
        
        profileSettingItem1.configuration = descriptionConfig
        profileSettingItem1.addAction(firstAction, for: .touchUpInside)
        
        var description2Config = UIButton.Configuration.filled()
        description2Config.baseBackgroundColor = .white
        description2Config.baseForegroundColor = .black
        description2Config.imagePadding = 10
        description2Config.imagePlacement = .leading

        var title2Attr = AttributedString.init(self.secondTitle)
        title2Attr.font = .systemFont(ofSize: 15.0, weight: .medium)
        
        let image2Config = UIImage.SymbolConfiguration(pointSize: 12, weight: .light)
        let setImage2 = UIImage(systemName: "person", withConfiguration: image2Config)
        
        description2Config.image = setImage2
        description2Config.attributedTitle = title2Attr
        
        profileSettingItem2.configuration = description2Config
        profileSettingItem2.addAction(secondAction, for: .touchUpInside)
    }
    
    private func setupLayouts() {
        self.layer.shadowColor = UIColor(hexCode: "c4c4c4").cgColor
        self.layer.shadowOpacity = 0.7
        self.layer.shadowRadius = 7
        self.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        
        self.stackView.layer.cornerRadius = 15
        self.stackView.layer.masksToBounds = true
        self.stackView.backgroundColor = .white
        self.stackView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.stackView.isLayoutMarginsRelativeArrangement = true
        
        [profileSettingItem1,
         profileSettingItem2].forEach {
            stackView.addArrangedSubview($0)
        }
                
        self.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
