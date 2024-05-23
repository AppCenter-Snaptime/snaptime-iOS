//
//  MyProfileViewController.swift
//  snaptime
//
//  Created by Bowon Han on 2/1/24.
//

import UIKit
import SnapKit

protocol MyProfileNavigation: AnyObject {
    func presentMyProfile()
    func presentSettingProfile()
}

final class MyProfileViewController: BaseViewController {
    weak var delegate: MyProfileNavigation?
    private let count: UserProfileCountModel.Result? = nil
    private let loginId = "bowon0000"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabSettingButton()
        
        APIService.fetchUserProfile(loginId: loginId).performRequest { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let userProfile):
                    if let profile = userProfile as? UserProfileModel {
                        self.profileStatusView.setupUserProfile(profile.result)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        APIService.fetchUserProfileCount(loginId: loginId).performRequest { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let userProfileCount):
                    if let profileCount = userProfileCount as? UserProfileCountModel {
                        self.profileStatusView.setupUserNumber(profileCount.result)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
        
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
    
    // MARK: - configUI
    private let iconLabel: UILabel = {
        let label = UILabel()
        label.text = "Profile"
        label.textColor = .snaptimeBlue
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .left
        
        return label
    }()
    
    private let notificationButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .systemBackground
        config.baseForegroundColor = .black
        config.image = UIImage(systemName: "bell")
        button.configuration = config
        
        return button
    }()
    
    private let profileStatusView = ProfileStatusView(target: .myself)
    
    private let albumAndTagListView = TopTapBarView()
    
    private func tabSettingButton() {
        profileStatusView.tabButtonAction = { [weak self] in
            self?.delegate?.presentSettingProfile()
        }
    }
    
    // MARK: - setupUI
    override func setupLayouts() {
        super.setupLayouts()
        [iconLabel,
         notificationButton,
         profileStatusView,
         albumAndTagListView].forEach {
            view.addSubview($0)
        }
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        iconLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(25)
            $0.width.equalTo(80)
            $0.height.equalTo(32)
        }
        
        notificationButton.snp.makeConstraints {
            $0.centerY.equalTo(iconLabel.snp.centerY)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-25)
            $0.height.width.equalTo(32)
        }
        
        profileStatusView.snp.makeConstraints {
            $0.top.equalTo(iconLabel.snp.bottom).offset(10.5)
            $0.left.right.equalTo(view.safeAreaLayoutGuide)
        }
        
        albumAndTagListView.snp.makeConstraints {
            $0.top.equalTo(profileStatusView.snp.bottom).offset(8)
            $0.left.right.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
