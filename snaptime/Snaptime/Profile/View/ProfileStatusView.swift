//
//  ProfileStatusView.swift
//  Snaptime
//
//  Created by Bowon Han on 2/21/24.
//

import UIKit
import SnapKit
import Kingfisher

/// 프로필 이미지, 닉네임, 팔로잉,팔로워,게시글 버튼을 포함하고 있는 customView
/// 타인의 프로필과 나의 프로필 구별하기 위한 enum이 포함됨
final class ProfileStatusView: UIView {
    private var followOrSettingButtonAction: UIAction
    private var followingButtonAction: UIAction
    private var followerButtonAction: UIAction

    private let profileTarget: ProfileTarget
    
    private var action: ((String, String)->())?

    private var loginId: String?
    private var name: String?
    
    private var follow: Bool = true {
        didSet {
            updateFollowButtonTitle()
        }
    }
    
    init(target: ProfileTarget,
         followOrSettingAction: UIAction,
         followingAction: UIAction,
         followerAction: UIAction) {
        self.profileTarget = target
        self.followOrSettingButtonAction = followOrSettingAction
        self.followingButtonAction = followingAction
        self.followerButtonAction = followerAction
        super.init(frame: .zero)
        self.setupUI(target: target)
        self.setupLayouts()
        self.setupConstraints()
        
        self.followOrSettingButton.addAction(followOrSettingButtonAction, for: .touchUpInside)
        self.followerNumber.addAction(followerAction, for: .touchUpInside)
        self.followingNumber.addAction(followingAction, for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
    }
    
    private lazy var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .snaptimeGray
        
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
    
    private lazy var postNumber = ProfileStatusButton("사진수")
    private lazy var followerNumber = ProfileStatusButton("팔로워")
    private lazy var followingNumber = ProfileStatusButton("팔로잉")
    
    private let lineView : UIView = {
        let view = UIView()
        view.backgroundColor = .snaptimelightGray
        
        return view
    }()
    
    func setAction(action: ((String, String)->())?) {
        self.action = action
    }
    
    func followButtonToggle() {
        follow.toggle()
    }
    
    // MARK: - 팔로잉, 팔로우 버튼 다르게 보이도록 구현
    private func updateFollowButtonTitle() {
        var config = followOrSettingButton.configuration

        switch follow {
        case true:
            config?.baseForegroundColor = .snaptimeBlue
            config?.background.backgroundColor = .white
            config?.background.strokeColor = .snaptimeBlue
        case false:
            config?.baseBackgroundColor = .snaptimeBlue
            config?.baseForegroundColor = .white
            config?.background.backgroundColor = .snaptimeBlue
        }
        
        var titleAttr = AttributedString(follow ? "팔로잉" : "팔로우")
        titleAttr.font = .systemFont(ofSize: 12, weight: .semibold)
        
        config?.attributedTitle = titleAttr
        followOrSettingButton.configuration = config
    }
    
    func followButtonclick() {
        if follow {
            if let action = self.action,
               let name = self.name,
               let loginId = self.loginId {
                action(name, loginId)
            }
        }
        
        else if !follow {
            guard let loginId = self.loginId else { return }
            APIService.postFollow(loginId: loginId).performRequest { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                        self.followButtonToggle()
                        self.fetchUserProfileCount(loginId: loginId)
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
    }
    
    private func fetchUserProfileCount(loginId: String) {
        APIService.fetchUserProfileCount(loginId: loginId).performRequest { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let userProfileCount):
                    if let profileCount = userProfileCount as? CommonResponseDtoProfileCntResDto {
                        self.setupUserNumber(profileCount.result)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }

    // MARK: - target에 따른 button UI 세팅하는 함수
    private func setupUI(target: ProfileTarget) {
        var config = UIButton.Configuration.filled()

        switch target {
        case .others:
            switch follow {
            case true:
                config.baseForegroundColor = .snaptimeBlue
                config.background.backgroundColor = .white
                config.background.strokeColor = .snaptimeBlue
            case false:
                config.baseBackgroundColor = .snaptimeBlue
                config.baseForegroundColor = .white
                config.background.backgroundColor = .snaptimeBlue
            }
            
            var titleAttr = AttributedString(follow ? "팔로잉" : "팔로우")
            titleAttr.font = .systemFont(ofSize: 12, weight: .semibold)
            config.attributedTitle = titleAttr
            
        case .myself:
            config.baseBackgroundColor = .white
            config.baseForegroundColor = .black
            let imageConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .light)
            let setImage = UIImage(systemName: "ellipsis", withConfiguration: imageConfig)
            config.image = setImage
            
            followOrSettingButton.transform = CGAffineTransform(rotationAngle: .pi * 0.5)
        }
        
        followOrSettingButton.configuration = config
    }
    
    // MARK: - 이름과 프로필 이미지 세팅하는 함수
    func setupUserProfile(_ userProfile: UserProfileResDto, loginId: String) {
        APIService.loadImageNonToken(data: userProfile.profileURL, imageView: profileImage)
        self.nickNameLabel.text = userProfile.userName
        
        if let follow = userProfile.isFollow {
            self.follow = follow
        }
        
        self.loginId = loginId
        self.name = userProfile.userName
    }
    
    func setupUserNumber(_ userProfileCount: ProfileCntResDto) {
        self.postNumber.setupNumber(number: userProfileCount.snapCnt)
        self.followerNumber.setupNumber(number: userProfileCount.followerCnt)
        self.followingNumber.setupNumber(number: userProfileCount.followingCnt)
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
