//
//  ProfileStatusView.swift
//  Snaptime
//
//  Created by Bowon Han on 2/21/24.
//

import UIKit
import SnapKit

/// 프로필 이미지, 닉네임, 팔로잉,팔로워,게시글 버튼을 포함하고 있는 customView
/// 타인의 프로필과 나의 프로필 구별하기 위한 enum이 포함됨 
final class ProfileStatusView: UIView {
    enum ProfileTarget {
        case myself
        case others
    }
    
    var tabButtonAction: UIAction
    let profileTarget: ProfileTarget
    
    init(target: ProfileTarget, action: UIAction) {
        self.profileTarget = target
        self.tabButtonAction = action
        super.init(frame: .zero)
        self.setupUI(target: target)
        self.setupLayouts()
        self.setupConstraints()
        self.followOrSettingButton.addAction(tabButtonAction, for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImage.layer.cornerRadius = profileImage.frame.height/2
    }
    
    private lazy var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .snaptimeGray
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private lazy var nickNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .left
        
        return label
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 35
        
        return stackView
    }()
    
    private lazy var followOrSettingButton = UIButton()
    
    private lazy var postNumber = ProfileStatusButton("사진수", action: UIAction {[weak self] _ in})
    private lazy var followerNumber = ProfileStatusButton("팔로워", action: UIAction {[weak self] _ in})
    private lazy var followingNumber = ProfileStatusButton("팔로잉", action: UIAction {[weak self] _ in})
    
    private let lineView : UIView = {
        let view = UIView()
        view.backgroundColor = .snaptimelightGray
        
        return view
    }()
    
    // MARK: - target에 따른 button UI 세팅하는 함수
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
    
    // MARK: - 이름과 프로필 이미지 세팅하는 함수
    func setupUserProfile(_ userProfile: UserProfileResDTO) {
        self.loadImage(data: userProfile.profileURL)
        self.nickNameLabel.text = userProfile.userName
    }
    
    func setupUserNumber(_ userProfileCount: UserProfileCountResDTO) {
        self.postNumber.setupNumber(number: userProfileCount.snapCnt)
        self.followerNumber.setupNumber(number: userProfileCount.followerCnt)
        self.followingNumber.setupNumber(number: userProfileCount.followingCnt)
    }
    
    // MARK: - 네트워크로부터 이미지 받아오는 함수
    private func loadImage(data: String) {
        guard let url = URL(string: data)  else { return }
        
        let backgroundQueue = DispatchQueue(label: "background_queue",qos: .background)
        
        backgroundQueue.async {
            guard let data = try? Data(contentsOf: url) else { return }
            
            DispatchQueue.main.async {
                self.profileImage.image = UIImage(data: data)
            }
        }
    }
    
    // MARK: - view 계층
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
    
    // MARK: - constraint
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
