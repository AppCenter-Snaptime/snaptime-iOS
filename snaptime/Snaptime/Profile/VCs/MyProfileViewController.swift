//
//  MyProfileViewController.swift
//  snaptime
//
//  Created by Bowon Han on 2/1/24.
//

import UIKit
import SnapKit

protocol MyProfileViewControllerDelegate: AnyObject {
    func presentMyProfile()
    func presentSettingProfile()
    func presentAlbumDetail()
}

final class MyProfileViewController: BaseViewController {
    weak var delegate: MyProfileViewControllerDelegate?
        
    private let count: UserProfileCountModel.Result? = nil
    private let loginId = "bowon0000"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.albumListView.flow = sendFlow
        self.listScrollView.delegate = self

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
                    self.albumListView.reloadData()
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
    
    private lazy var profileStatusView = ProfileStatusView(target: .myself,
                                                           action: UIAction { _ in
        self.delegate?.presentSettingProfile()
    })
    
    private lazy var albumAndTagListView = TopTapBarView()
    
    private lazy var listScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.isDirectionalLockEnabled = true
        
        return scrollView
    }()
        
    private lazy var tagListView = TagListView()
    private lazy var albumListView = AlbumListView()
    
    private lazy var contentView = UIView()

    
    private func sendFlow() {
        self.delegate?.presentAlbumDetail()
    }
    
    // MARK: - setupUI
    override func setupLayouts() {
        super.setupLayouts()
        
        [albumListView,
         tagListView].forEach {
            contentView.addSubview($0)
        }
        
        listScrollView.addSubview(contentView)
        
        [iconLabel,
         notificationButton,
         profileStatusView,
         albumAndTagListView,
         listScrollView].forEach {
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
            $0.height.equalTo(43)
        }
        
        let scrollViewWidth = UIScreen.main.bounds.width

        listScrollView.snp.makeConstraints {
            $0.top.equalTo(albumAndTagListView.snp.bottom).offset(1)
            $0.left.right.bottom.equalToSuperview()
        }
                        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(listScrollView.contentLayoutGuide)
            $0.height.equalTo(listScrollView.frameLayoutGuide)
            $0.width.equalTo(scrollViewWidth*2)
        }
        
        albumListView.snp.makeConstraints {
            $0.top.left.bottom.equalTo(contentView)
            $0.width.equalTo(scrollViewWidth)
        }
        
        tagListView.snp.makeConstraints {
            $0.top.bottom.equalTo(contentView)
            $0.left.equalTo(albumListView.snp.right)
            $0.width.equalTo(scrollViewWidth)
        }
    }
}

extension MyProfileViewController: UIScrollViewDelegate {
    
    /// scrollView 스크롤 시 indicator 바가 함께 움직이도록 하는 메서드
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let width = UIScreen.main.bounds.width
//        let offsetX = scrollView.contentOffset.x
        
//        self.indicatorView.snp.remakeConstraints {
//            $0.top.equalTo(self.tapBarCollectionView.snp.bottom)
//            $0.height.equalTo(2)
//            $0.centerX.equalTo(offsetX/2 + width/4)
//            $0.width.equalTo(width/6)
//        }
        
        UIView.animate(
            withDuration: 0.1,
            animations: { self.listScrollView.layoutIfNeeded() }
        )
    }
}
