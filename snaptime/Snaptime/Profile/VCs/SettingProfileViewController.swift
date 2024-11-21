//
//  SettingProfileViewController.swift
//  snaptime
//
//  Created by Bowon Han on 2/1/24.
//

import UIKit
import SnapKit
import Kingfisher

protocol SettingProfileViewControllerDelegate: AnyObject {
    func presentSettingProfile()
    func presentEditProfile()
    func backToPrevious()
    func presentLogin()
    func presentCancelAccount()
}

final class SettingProfileViewController: BaseViewController {
    weak var delegate: SettingProfileViewControllerDelegate?
    private var userProfile = UserProfileManager.shared.profile.result
    
    private let loginId = ProfileBasicUserDefaults().email
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.idLabel.text = userProfile.userName
        APIService.loadImageNonToken(data: userProfile.profileURL, imageView: profileImage)
        self.setNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        profileImage.layer.cornerRadius = profileImage.frame.height/2
    }
    
    private lazy var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .snaptimeGray
        imageView.clipsToBounds = true

        return imageView
    }()
    
    private lazy var idLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: SuitFont.bold, size: 24)
        
        return label
    }()
    
    private let contentView = UIView()
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    
//    private lazy var settingProfileView1 = ProfileSettingView(first: "프로필 편집",
//                                                         second: "알림",
//                                                         firstAction: UIAction { [weak self] _ in
//        self?.delegate?.presentEditProfile()
//    },
//                                                         secondAction: UIAction { [weak self] _ in
//    })
    
    private lazy var settingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 5
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        
        let editProfileButton = SettingButton(title: "프로필 편집", imageName: "person")
        let alertButton = SettingButton(title: "알림", imageName: "bell")
        
        editProfileButton.addAction(UIAction{[weak self] _ in
            self?.delegate?.presentEditProfile()
        }, for: .touchUpInside)
        
        [editProfileButton, alertButton].forEach {
            stackView.addArrangedSubview($0)
        }
    
        return stackView
    }()

    
    private lazy var settingLinkStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 5
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        
        let helpButton = SettingButton(title: "Help & Support", imageName: "person")
        let faqButton = SettingButton(title: "FAQ", imageName: "bubble.left.and.text.bubble.right")
        let securityButton = SettingButton(title: "보안정책", imageName: "lock")
        
        [helpButton, faqButton, securityButton].forEach {
            stackView.addArrangedSubview($0)
        }
    
        return stackView
    }()
    
    private lazy var changePasswordButton: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.plain()
        var titleAttr = AttributedString.init("비밀번호 변경")
        titleAttr.font = UIFont(name: SuitFont.medium, size: 14)
        
        config.baseBackgroundColor = .white
        config.baseForegroundColor = .black
        config.titleAlignment = .leading
        config.attributedTitle = titleAttr
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 25, bottom: 0, trailing: 0)
        
        button.configuration = config
        button.contentHorizontalAlignment = .leading
        
        return button
    }()
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.plain()
        var titleAttr = AttributedString.init("로그아웃")
        titleAttr.font = UIFont(name: SuitFont.medium, size: 14)
        
        config.baseBackgroundColor = .white
        config.baseForegroundColor = .black
        config.titleAlignment = .leading
        config.attributedTitle = titleAttr
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 25, bottom: 0, trailing: 0)
        
        button.configuration = config
        button.contentHorizontalAlignment = .leading
        button.addAction(UIAction {[weak self] _ in
            self?.show(
                alertText: "로그아웃 하시겠습니까?",
                cancelButtonText: "취소하기",
                confirmButtonText: "네",
                identifier: "signout"
            )
        }, for: .touchUpInside)

        return button
    }()
    
    private lazy var deleteUserButton: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.plain()
        var titleAttr = AttributedString.init("회원 탈퇴")
        titleAttr.font = UIFont(name: SuitFont.medium, size: 14)
        
        config.baseBackgroundColor = .white
        config.baseForegroundColor = .black
        config.titleAlignment = .leading
        config.attributedTitle = titleAttr
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 25, bottom: 0, trailing: 0)

        button.configuration = config
        button.contentHorizontalAlignment = .leading
        button.addAction(UIAction{[weak self] _ in
            self?.delegate?.presentCancelAccount()
        }, for: .touchUpInside)
        
        return button
    }()
        
    private func signoutLogic() {
        let checkTokenDeleted = KeyChain.deleteTokens(accessKey: TokenType.accessToken.rawValue, refreshKey: TokenType.refreshToken.rawValue)
        
        ProfileBasicUserDefaults().email = nil
        
        if checkTokenDeleted.access && checkTokenDeleted.refresh {
            delegate?.presentLogin()
        }
    }
    
    private func deleteUserLogic(password: String) {
        APIService.deleteUser(password: password).performRequest(responseType: CommonResDtoVoid.self) { result in
            switch result {
            case .success(_):
                let checkTokenDeleted = KeyChain.deleteTokens(accessKey: TokenType.accessToken.rawValue, refreshKey: TokenType.refreshToken.rawValue)
                
                ProfileBasicUserDefaults().email = nil
                
                if checkTokenDeleted.access && checkTokenDeleted.refresh {
                    self.delegate?.presentLogin()
                }
            case .failure(let error):
                print("유저 삭제 성공")
                print(error)
            }
        }
    }
    
    private func setNavigationBar() {
        self.showNavigationBar()
    }

    // MARK: - Set Layouts
    override func setupLayouts() {
        super.setupLayouts()
        
        [profileImage,
         idLabel,
         scrollView].forEach {
            view.addSubview($0)
        }
        
        scrollView.addSubview(contentView)
        
        [settingStackView,
         settingLinkStackView,
         changePasswordButton,
         logoutButton,
         deleteUserButton
        ].forEach{
            contentView.addSubview($0)
        }
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        [settingLinkStackView,
         settingStackView
        ].forEach {
            $0.isLayoutMarginsRelativeArrangement = true
        }
        
        [settingStackView,
         settingLinkStackView,
         changePasswordButton,
         logoutButton,
         deleteUserButton].forEach {
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.init(hexCode: "d0d0d0").cgColor
            $0.layer.cornerRadius = 8
            $0.layer.masksToBounds = true
            $0.backgroundColor = .white
            $0.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
        
        profileImage.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(25)
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
            $0.height.width.equalTo(120)
        }
        
        idLabel.snp.makeConstraints {
            $0.top.equalTo(profileImage.snp.bottom).offset(16)
            $0.centerX.equalTo(profileImage.snp.centerX)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(idLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.height.equalTo(500)
        }
        
        settingStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.left.equalToSuperview().offset(30)
            $0.right.equalToSuperview().offset(-30)
        }
        
        settingLinkStackView.snp.makeConstraints {
            $0.top.equalTo(settingStackView.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(30)
            $0.right.equalToSuperview().offset(-30)
        }
        
//        changePasswordButton.snp.makeConstraints {
//            $0.top.equalTo(settingLinkStackView.snp.bottom).offset(20)
//            $0.left.equalToSuperview().offset(30)
//            $0.right.equalToSuperview().offset(-30)
//            $0.height.equalTo(50)
//        }
        
        logoutButton.snp.makeConstraints {
            $0.top.equalTo(settingLinkStackView.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(30)
            $0.right.equalToSuperview().offset(-30)
            $0.height.equalTo(50)
        }
        
        deleteUserButton.snp.makeConstraints {
            $0.top.equalTo(logoutButton.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(30)
            $0.right.equalToSuperview().offset(-30)
            $0.height.equalTo(50)
        }
    }
}

extension SettingProfileViewController: CustomAlertDelegate {
    func exit(identifier: String) {}
    
    func action(identifier: String) {
        switch identifier {
        case "signout":
            self.signoutLogic()
        default:
            print("none")
        }
    }
    
}
