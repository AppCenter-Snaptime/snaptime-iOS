//
//  FollowTableViewCell.swift
//  Snaptime
//
//  Created by Bowon Han on 7/5/24.
//

import UIKit
import SnapKit

final class FollowTableViewCell: UITableViewCell {
    private var follow: Bool = false {
        didSet {
            updateFollowButtonTitle()
        }
    }
    
    private var type: ProfileTarget = .others {
        didSet {
            configButtonType()
        }
    }
    
    private var email: String?
    private var action: ((String, String)->())?
    private var name: String = ""
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupLayouts()
        self.setupConstraints()
        self.updateFollowButtonTitle()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    private lazy var profileImageView: RoundImageView = {
        let imageView = RoundImageView()
        imageView.backgroundColor = .snaptimeGray
        
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: SuitFont.bold, size: 15)
        label.textColor = .black
        
        return label
    }()
    
//    private lazy var nickNameLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont(name: SuitFont.semiBold, size: 10)
//        label.textColor = .gray
//        label.text = "bowon0000"
//        
//        return label
//    }()
    
    private lazy var followButton: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.filled()
        config.background.cornerRadius = 50
        button.configuration = config
        button.isEnabled = true
        
        button.addAction(UIAction { [weak self] _ in
            switch self?.type {
            case .myself:
                button.isEnabled = false
            case .others:
                switch self?.follow {
                case true:
                    if let action = self?.action,
                        let name = self?.name,
                       let loginId = self?.email{
                        action(name, loginId)
                    }
                    
                    // TODO: - 이후 팔로잉 삭제 요청 필요
                case false:
                    if let loginId = self?.email {
                        APIService.postFollow(email: loginId).performRequest(responseType: CommonResDtoVoid.self) { result in
                            switch result {
                            case .success(_):
                                DispatchQueue.main.async {
                                    self?.follow.toggle()
                                }
                            case .failure(let error):
                                print(error)
                            }
                        }
                    }
                case .none:
                    print("")
                    
                case .some(_):
                    print("")
                }
            case .none:
                break
            }
            
        }, for: .touchUpInside)

        return button
    }()
    
    /// 팔로워, 팔로우 목록에서 나의 프로필인지, 타인의 프로필인지에 따라 버튼 config
    private func configButtonType() {
        var config = followButton.configuration

        switch type {
        case .myself:
            let titleAttr = AttributedString("")
            config?.baseBackgroundColor = .white
            config?.background.backgroundColor = .white
            config?.baseForegroundColor = .white
            config?.background.strokeColor = .white
            config?.attributedTitle = titleAttr
            
        case .others:
            self.updateFollowButtonTitle()
        }
        
        followButton.configuration = config
    }
    
    /// 맞팔 유무에 따라 버튼의 상태를 선택하는 메서드
    private func updateFollowButtonTitle() {
        var config = followButton.configuration

        switch follow {
        case true:
            var titleAttr = AttributedString("팔로잉")
            titleAttr.font = UIFont(name: SuitFont.bold, size: 15)
            config?.baseForegroundColor = .black
            config?.background.backgroundColor = .white
            config?.background.strokeColor = .followButtonGray
            config?.attributedTitle = titleAttr
        case false:
            var titleAttr = AttributedString("팔로우하기")
            titleAttr.font = UIFont(name: SuitFont.bold, size: 15)
            config?.baseBackgroundColor = .followButtonGray
            config?.background.backgroundColor = .followButtonGray
            config?.baseForegroundColor = .white
            config?.attributedTitle = titleAttr
        }

        followButton.configuration = config
    }
    
    /// VC로부터 데이터를 받아오는 메서드
    func configData(data: FriendInfo) {
        self.email = data.foundEmail
        /// 현재 사용자 자신의 프로필이라면 type을 myself로 설정
        
        data.foundEmail == ProfileBasicUserDefaults().email ?
        (type = .myself) :
        (follow = data.isMyFriend)
        
        APIService.loadImageNonToken(data: data.profilePhotoURL, imageView: profileImageView)
        nameLabel.text = data.foundUserName
        self.name = data.foundUserName
    }
    
    func setAction(action: ((String, String)->())?) {
        self.action = action
    }
    
    // MARK: - UI Layouts config
    private func setupLayouts() {
        [profileImageView, 
         nameLabel,
//         nickNameLabel,
         followButton].forEach {
            contentView.addSubview($0)
        }
    }
    
    // MARK: - UI Constraints config
    private func setupConstraints() {
        profileImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.left.equalToSuperview().offset(20)
            $0.width.height.equalTo(56)
        }
        
        nameLabel.snp.makeConstraints {
//            $0.top.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
            $0.left.equalTo(profileImageView.snp.right).offset(20)
            $0.right.equalTo(followButton.snp.left).offset(-20)
        }
        
//        nickNameLabel.snp.makeConstraints {
//            $0.top.equalTo(nameLabel.snp.bottom).offset(3)
//            $0.left.equalTo(nameLabel.snp.left)
//        }
        
        followButton.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView.snp.centerY)
            $0.right.equalToSuperview().offset(-20)
            $0.width.equalTo(104)
            $0.height.equalTo(35)
        }
    }
}
