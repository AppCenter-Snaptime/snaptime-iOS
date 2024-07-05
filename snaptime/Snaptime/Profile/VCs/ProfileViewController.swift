//
//  MyProfileViewController.swift
//  snaptime
//
//  Created by Bowon Han on 2/1/24.
//

import UIKit
import SnapKit

protocol ProfileViewControllerDelegate: AnyObject {
    func presentMyProfile(target: ProfileTarget)
    func presentSettingProfile()
    func presentSnapPreview(albumId: Int)
    func presentNotification()
    func presentFollow(target: FollowTarget)
}

enum ProfileTarget {
    case myself
    case others
}

final class ProfileViewController: BaseViewController {
    weak var delegate: ProfileViewControllerDelegate?
        
    private let count: UserProfileCountResDTO? = nil
    private let loginId = ProfileBasicModel.profile.loginId
    
    private let target: ProfileTarget
    
    init(target: ProfileTarget) {
        self.target = target
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.albumAndTagListView.send = sendFlow
        self.setupNavigationBar()

        self.fetchUserAlbum(loginId: loginId)
        self.fetchUserProfile(loginId: loginId)
        self.fetchUserProfileCount(loginId: loginId)
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
    
    private lazy var profileStatusView = ProfileStatusView(
        target: .myself,
        followOrSettingAction: UIAction { [weak self] _ in
            self?.delegate?.presentSettingProfile()
        },
        followingAction: UIAction { [weak self] _ in
            self?.delegate?.presentFollow(target: .following)
        },
        followerAction: UIAction { [weak self] _ in
            self?.delegate?.presentFollow(target: .follower)
        })
    
    private let albumAndTagListView = TopTapBarView()
        
    private var sendFlow: (Int) -> Void {
        return { [weak self] albumId in
            self?.delegate?.presentSnapPreview(albumId: albumId)
        }
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: iconLabel)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: notificationButton)
    }
    
    private func fetchUserProfile(loginId: String) {
        APIService.fetchUserProfile(loginId: loginId).performRequest { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let userProfile):
                    if let profile = userProfile as? UserProfileResponse {
                        self.profileStatusView.setupUserProfile(profile.result)
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
                    if let profileCount = userProfileCount as? UserProfileCountResponse {
                        self.profileStatusView.setupUserNumber(profileCount.result)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func fetchUserAlbum(loginId: String) {
        APIService.fetchUserAlbum(loginId: loginId).performRequest { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self.albumAndTagListView.reloadAlbumListView()
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