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
    
    private let loginId = ProfileBasicUserDefaults().loginId
    
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
    
    private lazy var iconButton: UIButton = {
        let button = UIButton()

        var buttonConfig = UIButton.Configuration.filled()
        buttonConfig.baseBackgroundColor = .white
        buttonConfig.baseForegroundColor = .snaptimeBlue
        
        var titleAttr = AttributedString.init("Profile")
        titleAttr.font = .systemFont(ofSize: 25, weight: .medium)
        let imageConfig = UIImage.SymbolConfiguration(hierarchicalColor: .black)

        let setImage = UIImage(systemName: "chevron.backward", withConfiguration: imageConfig)
        
        buttonConfig.attributedTitle = titleAttr
        buttonConfig.image = setImage
        buttonConfig.imagePlacement = .leading
        buttonConfig.imagePadding = 5
        
        button.configuration = buttonConfig
        button.addAction(UIAction{ [weak self] _ in
            self?.delegate?.backToPrevious()
        }, for: .touchUpInside)
                
        return button
    }()
    
    private lazy var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .snaptimeGray
        imageView.clipsToBounds = true

        return imageView
    }()
    
    private lazy var idLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        
        return label
    }()
    
    private let contentView = UIView()
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    
    private lazy var settingProfileView1 = ProfileSettingView(first: "프로필 편집",
                                                         second: "알림",
                                                         firstAction: UIAction { [weak self] _ in
        self?.delegate?.presentEditProfile()
    },
                                                         secondAction: UIAction { [weak self] _ in
    })
    private lazy var settingProfileView2 = ProfileSettingView(first: "Help&Support",
                                                         second: "FAQ",
                                                         firstAction: UIAction { [weak self] _ in
    },
                                                         secondAction: UIAction { [weak self] _ in
    })
    private lazy var settingProfileView3 = ProfileSettingView(first: "보안 정책",
                                                         second: "수정",
                                                         firstAction: UIAction { [weak self] _ in
    },
                                                         secondAction: UIAction { [weak self] _ in
    })
    
    private lazy var settingProfileView4 = ProfileSettingView(first: "로그아웃",
                                                        second: "탈퇴하기",
                                                        firstAction: UIAction { [weak self] _ in
        self?.show(
            alertText: "로그아웃 하시겠습니까?",
            cancelButtonText: "취소하기",
            confirmButtonText: "네",
            identifier: "signout"
        )
    },
                                                        secondAction: UIAction { [weak self] _ in
        self?.delegate?.presentCancelAccount()
    })
    
    private func signoutLogic() {
        let checkTokenDeleted = KeyChain.deleteTokens(accessKey: TokenType.accessToken.rawValue, refreshKey: TokenType.refreshToken.rawValue)
        
        ProfileBasicUserDefaults().loginId = nil
        
        if checkTokenDeleted.access && checkTokenDeleted.refresh {
            delegate?.presentLogin()
        }
    }
    
    private func deleteUserLogic(password: String) {
        APIService.deleteUser(password: password).performRequest(responseType: CommonResDtoVoid.self) { result in
            switch result {
            case .success(_):
                let checkTokenDeleted = KeyChain.deleteTokens(accessKey: TokenType.accessToken.rawValue, refreshKey: TokenType.refreshToken.rawValue)
                
                ProfileBasicUserDefaults().loginId = nil
                
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
        
        [settingProfileView1,
         settingProfileView2,
         settingProfileView3,
         settingProfileView4].forEach{
            contentView.addSubview($0)
        }
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        profileImage.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
            $0.height.width.equalTo(120)
        }
        
        idLabel.snp.makeConstraints {
            $0.top.equalTo(profileImage.snp.bottom).offset(20)
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
        
        settingProfileView1.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.left.equalToSuperview().offset(30)
            $0.right.equalToSuperview().offset(-30)
        }
        
        settingProfileView2.snp.makeConstraints {
            $0.top.equalTo(settingProfileView1.snp.bottom).offset(30)
            $0.left.equalToSuperview().offset(30)
            $0.right.equalToSuperview().offset(-30)
        }
        
        settingProfileView3.snp.makeConstraints {
            $0.top.equalTo(settingProfileView2.snp.bottom).offset(30)
            $0.left.equalToSuperview().offset(30)
            $0.right.equalToSuperview().offset(-30)
        }
        
        settingProfileView4.snp.makeConstraints {
            $0.top.equalTo(settingProfileView3.snp.bottom).offset(30)
            $0.left.equalToSuperview().offset(30)
            $0.right.equalToSuperview().offset(-30)
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
