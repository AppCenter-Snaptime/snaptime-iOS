//
//  ButtonStackView.swift
//  snaptime
//
//  Created by Bowon Han on 2/2/24.
//

import UIKit
import SnapKit

class ButtonStackView : UIView {
    private let stackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 15
        stackView.backgroundColor = .white
        
        return stackView
    }()
    
    private let mainButton = UIButton()
    private let settingButton = UIButton()
    private let listImageButton = UIButton()
    private let profileButton = UIButton()
    
    private func buttonConfig() {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25,
                                                      weight: .medium,
                                                      scale: .small)
        let mainImage = UIImage(systemName: "house", withConfiguration: imageConfig)
        let listImage = UIImage(systemName: "hanger", withConfiguration: imageConfig)
        let settingImage = UIImage(systemName: "ellipsis", withConfiguration: imageConfig)
        let profileImage = UIImage(systemName: "person", withConfiguration: imageConfig)
        
        mainButton.setImage(mainImage, for: .normal)
        listImageButton.setImage(listImage, for: .normal)
        settingButton.setImage(settingImage, for: .normal)
        profileButton.setImage(profileImage, for: .normal)
        
        [mainButton,
         listImageButton,
         settingButton,
         profileButton].forEach {
            $0.layer.cornerRadius = 10
            $0.backgroundColor = .white
            $0.imageView?.tintColor = .black
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buttonConfig()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setLayout(){
        [mainButton,
         listImageButton,
         settingButton,
         profileButton].forEach {
            stackView.addArrangedSubview($0)
        }
        
        [mainButton,
         listImageButton,
         settingButton,
         profileButton].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(40)
            }
        }
        
        addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(self)
        }
    }
}


