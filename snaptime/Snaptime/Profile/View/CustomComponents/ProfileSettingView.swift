//
//  SettingView.swift
//  Snaptime
//
//  Created by Bowon Han on 3/9/24.
//

import UIKit
import SnapKit

final class ProfileSettingView: UIView {
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.setupLayouts()
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
    
    private let profileSettingItem1 = ProfileSettingItemView(iconName: "bell", description: "알림")
    private let profileSettingItem2 = ProfileSettingItemView(iconName: "person", description: "프로필 수정")
    
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
