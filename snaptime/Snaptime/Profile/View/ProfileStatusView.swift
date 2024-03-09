//
//  ProfileStatusView.swift
//  Snaptime
//
//  Created by Bowon Han on 2/21/24.
//

import UIKit
import SnapKit

/// 프로필 이미지, 닉네임, 팔로잉,팔로워,게시글 버튼을 포함하고 있는 customView
/// // 타인의 프로필과 나의 프로필 구별하기 위한 enum이 포함됨 
final class ProfileStatusView : UIView {
    enum ProfileTarget {
        case myself
        case others
    }
    
    var tabButtonAction : (() -> ())?

    let profileTarget : ProfileTarget
    
    init(target: ProfileTarget) {
        self.profileTarget = target
        super.init(frame: .zero)
        self.setupUI(target: target)
        self.setupLayouts()
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
    }
    
    private let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .snaptimeGray
        
        return imageView
    }()
    
    private let nickNameLabel: UILabel = {
        let label = UILabel()
        label.text = "blwxnhan"
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.textAlignment = .left
        
        return label
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 35
        
        return stackView
    }()
    
    private let followOrSettingButton = UIButton()
    
    private lazy var postNumber = ProfileStatusButton("사진수", "40")
    private lazy var followerNumber = ProfileStatusButton("팔로워", "342")
    private lazy var followingNumber = ProfileStatusButton("팔로잉", "342")
    
    private let lineView : UIView = {
        let view = UIView()
        view.backgroundColor = .snaptimelightGray
        
        return view
    }()
    
    @objc private func tabButton() {
        tabButtonAction?()
    }
    
    private func setupUI(target: ProfileTarget) {
        switch target {
        case .others:
            var config = UIButton.Configuration.filled()
            config.baseBackgroundColor = .snaptimeBlue
            config.baseForegroundColor = .white
            
            var titleAttr = AttributedString.init("팔로우")
            titleAttr.font = .systemFont(ofSize: 12, weight: .light)
            config.attributedTitle = titleAttr
            
            followOrSettingButton.configuration = config
            
        case .myself:
            var config = UIButton.Configuration.filled()
            config.baseBackgroundColor = .white
            config.baseForegroundColor = .black
            let imageConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .light)
            let setImage = UIImage(systemName: "ellipsis", withConfiguration: imageConfig)
            config.image = setImage
            
            followOrSettingButton.transform = CGAffineTransform(rotationAngle: .pi * 0.5)
            followOrSettingButton.configuration = config
        }
    }
    
    private func setupLayouts() {
        [postNumber,
         followerNumber,
         followingNumber].forEach {
            buttonStackView.addArrangedSubview($0)
        }
        
        [profileImage,
         nickNameLabel,
         buttonStackView,
         followOrSettingButton,
         lineView].forEach {
            addSubview($0)
        }
    }
    
    private func setupConstraints() {
        profileImage.snp.makeConstraints {
            $0.top.equalTo(self).offset(20)
            $0.left.equalTo(self).offset(25)
            $0.height.width.equalTo(80)
        }
        
        nickNameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImage.snp.top)
            $0.left.equalTo(profileImage.snp.right).offset(30)
            $0.width.equalTo(100)
            $0.height.equalTo(19)
        }
        
        followOrSettingButton.snp.makeConstraints {
            $0.centerY.equalTo(nickNameLabel.snp.centerY)
            $0.height.equalTo(25)
            $0.right.equalTo(self).offset(-25)
            switch profileTarget {
            case .myself:
                $0.width.equalTo(25)
            case .others:
                $0.width.equalTo(95)
            }
        }
            
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(nickNameLabel.snp.bottom).offset(18)
            $0.left.equalTo(profileImage.snp.right).offset(15)
            $0.right.equalTo(self).offset(-25)
            $0.bottom.equalTo(profileImage.snp.bottom)
        }
        
        lineView.snp.makeConstraints {
            $0.top.equalTo(profileImage.snp.bottom).offset(30)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(3)
            $0.bottom.equalToSuperview()
        }
    }
}
