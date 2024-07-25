//
//  ProfileViewController.swift
//  snaptime
//
//  Created by Bowon Han on 2/1/24.
//

import UIKit
import SnapKit

protocol ProfileViewControllerDelegate: AnyObject {
    func presentProfile(target: ProfileTarget, loginId: String)
    func presentSettingProfile()
    func presentSnapPreview(albumId: Int)
    func presentNotification()
    func presentFollow(target: FollowTarget, loginId: String)
}

enum ProfileTarget {
    case myself
    case others
}

final class ProfileViewController: BaseViewController {
    weak var delegate: ProfileViewControllerDelegate?
        
    private let count: ProfileCntResDto? = nil
    
    private var loginId: String
    private let target: ProfileTarget
    
    init(target: ProfileTarget, loginId: String) {
        self.target = target
        self.loginId = loginId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.albumAndTagListView.send = sendFlow
        
        self.setupNavigationBar()

        self.fetchUserProfile(loginId: loginId)
        self.fetchUserProfileCount(loginId: loginId)
        self.albumAndTagListView.setLoginId(loginId: loginId)
        self.profileStatusView.setAction(action: followButtonAction)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.fetchUserProfile(loginId: loginId)
        self.fetchUserProfileCount(loginId: loginId)
        self.albumAndTagListView.setLoginId(loginId: loginId)
    }
    
    // MARK: - configUI
    private let iconLabel: UILabel = {
        let label = UILabel()
        label.text = "Profile"
        label.textColor = .snaptimeBlue
        label.font = .systemFont(ofSize: 25, weight: .semibold)
        label.textAlignment = .left
        
        return label
    }()
    
    private lazy var notificationButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .systemBackground
        config.baseForegroundColor = .black
        config.image = UIImage(systemName: "bell")
        button.configuration = config
        button.addAction(UIAction{ [weak self] _ in
            self?.delegate?.presentNotification()
        }, for: .touchUpInside)
        
        return button
    }()
    
    private lazy var profileStatusView = ProfileStatusView (
        target: target,
        followOrSettingAction: UIAction { [weak self] _ in
            switch self?.target {
            case .myself:
                self?.delegate?.presentSettingProfile()
            case .others:
                self?.followButtonToggle()
            case .none:
                print("")
            }
        },
        followingAction: UIAction { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.presentFollow(target: .following, loginId: strongSelf.loginId)
        },
        followerAction: UIAction { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.presentFollow(target: .follower, loginId: strongSelf.loginId)
        }
    )
    
    private lazy var albumAndTagListView = TopTapBarView()
    
    private func followButtonAction(name: String) {
        show(
            alertText: "\(name)님을 언팔로우 하시겠어요?",
            cancelButtonText: "취소하기",
            confirmButtonText: "언팔로우"
        )
    }
        
    private var sendFlow: (Int) -> Void {
        return { [weak self] albumId in
            self?.delegate?.presentSnapPreview(albumId: albumId)
        }
    }
    
    // MARK: - navigationBar 설정
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: iconLabel)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: notificationButton)
    }
    
    private func followButtonToggle() {
        profileStatusView.followButtonclick()
    }
    
    // MARK: - 네트워크 로직
    private func fetchUserProfile(loginId: String) {
        APIService.fetchUserProfile(loginId: loginId).performRequest { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let userProfile):
                    if let profile = userProfile as? CommonResponseDtoUserProfileResDto {
                        self.profileStatusView.setupUserProfile(profile.result, loginId: self.loginId)
                    }
                case .failure(let error):
                    print(error)
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
                        self.profileStatusView.setupUserNumber(profileCount.result)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    // MARK: - setupUI
    override func setupLayouts() {
        super.setupLayouts()
        
        [profileStatusView,
         albumAndTagListView].forEach {
            view.addSubview($0)
        }
    }
    override func setupConstraints() {
        super.setupConstraints()
        
        profileStatusView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10.5)
            $0.left.right.equalTo(view.safeAreaLayoutGuide)
        }
        
        albumAndTagListView.snp.makeConstraints {
            $0.top.equalTo(profileStatusView.snp.bottom).offset(8)
            $0.left.right.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - extension
extension ProfileViewController: CustomAlertDelegate {
    func action() {
        
    }
    
    func exit() {}
}
