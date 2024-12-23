//
//  ProfileViewController.swift
//  snaptime
//
//  Created by Bowon Han on 2/1/24.
//

import UIKit
import SnapKit

protocol ProfileViewControllerDelegate: AnyObject {
    func presentProfile(target: ProfileTarget, email: String)
    func presentSettingProfile()
    func presentSnapPreview(albumId: Int)
    func presentNotification()
    func presentFollow(target: FollowTarget, email: String)
    func presentSnap(snapId: Int, profileType: ProfileTarget)
}

enum ProfileTarget {
    case myself
    case others
}

final class ProfileViewController: BaseViewController {
    weak var delegate: ProfileViewControllerDelegate?
        
    private let count: ProfileCntResDto? = nil
    
    private var email: String
    private let target: ProfileTarget
    
    private var unfollowLoginId: String?
    
    init(target: ProfileTarget, loginId: String) {
        self.target = target
        self.email = loginId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.albumListView.send = sendFlowAlbumList
        self.tagListView.send = sendFlowTagList
        self.profileStatusView.setAction(action: followButtonAction)
        

        self.fetchUserProfile(email: email)
        self.fetchUserProfileCount(email: email)
        
        self.sendData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.hideNavigationBar()
        self.fetchUserProfile(email: email)
        self.fetchUserProfileCount(email: email)
        self.sendData()
    }
    
    // MARK: - configUI
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
                self?.followButtonClick()
            case .none:
                print("")
            }
        },
        followingAction: UIAction { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.presentFollow(target: .following, email: strongSelf.email)
        },
        followerAction: UIAction { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.presentFollow(target: .follower, email: strongSelf.email)
        }
    )
        
    private lazy var tapBarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.decelerationRate = .fast
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TopTapBarCollectionViewCell.self, forCellWithReuseIdentifier: TopTapBarCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    private lazy var indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        
        return view
    }()
    
    private lazy var listScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.isDirectionalLockEnabled = true
        scrollView.delegate = self
        
        return scrollView
    }()
        
    private let tagListView = TagListView()
    private let albumListView = AlbumListView()
    
    private lazy var contentView = UIView()
    
    /// albumList, tagList에 각각 데이터 fetch할 수 있도록 loginId 전달
    private func sendData() {
        self.albumListView.setLoginId(loginId: self.email)
        self.tagListView.setEmail(email: self.email)
    }
    
    private func followButtonAction(name: String, loginId: String) {
        show(
            alertText: "\(name)님을 언팔로우 하시겠어요?",
            cancelButtonText: "취소하기",
            confirmButtonText: "언팔로우",
            identifier: "profileUnfollow"
        )
        
        self.unfollowLoginId = loginId
    }
        
    private var sendFlowAlbumList: (Int) -> Void {
        return { [weak self] albumId in
            self?.delegate?.presentSnapPreview(albumId: albumId)
        }
    }
    
    private var sendFlowTagList: (Int) -> Void {
        return { [weak self] snapId in
            guard let target = self?.target else { return }
            self?.delegate?.presentSnap(snapId: snapId, profileType: target)
        }
    }
    
    private func followButtonClick() {
        profileStatusView.followButtonclick()
    }
    
    // MARK: - 네트워크 로직
    private func fetchUserProfile(email: String) {
        APIService.fetchUserProfile(email: email).performRequest(responseType: CommonResponseDtoUserProfileResDto.self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let userProfile):
                    self.profileStatusView.setupUserProfile(userProfile.result, loginId: self.email)
                case .failure(let error):
                    print("fetchUserProfile",error)
                }
            }
        }
    }
    
    private func fetchUserProfileCount(email: String) {
        APIService.fetchUserProfileCount(email: email).performRequest(responseType: CommonResponseDtoProfileCntResDto.self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let userProfileCount):
                    self.profileStatusView.setupUserNumber(userProfileCount.result)
                case .failure(let error):
                    print("fetchUserProfileCount", error)
                }
            }
        }
    }
    
    // MARK: - setupUI
    override func setupLayouts() {
        super.setupLayouts()
        
        [profileStatusView,
         tapBarCollectionView,
          indicatorView,
          listScrollView].forEach {
            view.addSubview($0)
        }
        
        [albumListView,
         tagListView].forEach {
            contentView.addSubview($0)
        }
        
        listScrollView.addSubview(contentView)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        profileStatusView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.left.right.equalTo(view.safeAreaLayoutGuide)
        }
        
        tapBarCollectionView.snp.makeConstraints {
            $0.top.equalTo(profileStatusView.snp.bottom).offset(8)
            $0.left.right.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(40)
        }
        
        let scrollViewWidth = UIScreen.main.bounds.width

        indicatorView.snp.makeConstraints {
            $0.top.equalTo(tapBarCollectionView.snp.bottom)
            $0.height.equalTo(2)
            $0.centerX.equalTo(scrollViewWidth/4)
            $0.width.equalTo(scrollViewWidth/6)
        }
        
        listScrollView.snp.makeConstraints {
            $0.top.equalTo(indicatorView.snp.bottom).offset(1)
            $0.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
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

// MARK: - extension
extension ProfileViewController: CustomAlertDelegate {
    func action(identifier: String) {
        guard let unfollowLoginId = self.unfollowLoginId else { return }
        
        APIService.deleteFollowing(email: unfollowLoginId).performRequest(responseType: CommonResDtoVoid.self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    print("팔로우 취소")
                    self.profileStatusView.followButtonToggle()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func exit(identifier: String) {}
}

// MARK: - CollectionView extension
extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = tapBarCollectionView.dequeueReusableCell(
            withReuseIdentifier: TopTapBarCollectionViewCell.identifier,
            for: indexPath
        ) as? TopTapBarCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let title = ["앨범목록", "태그목록"]
        cell.configTitle(title[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == tapBarCollectionView {
            guard let cell = tapBarCollectionView.cellForItem(at: indexPath) as? TopTapBarCollectionViewCell else { return }
            
            let width = collectionView.bounds.width
            let scrollViewStart = width * CGFloat(indexPath.row)
            
            self.indicatorView.snp.remakeConstraints {
                $0.top.equalTo(self.tapBarCollectionView.snp.bottom)
                $0.height.equalTo(2)
                $0.centerX.equalTo(cell.snp.centerX)
                $0.width.equalTo(width/6)
            }
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
                self.listScrollView.setContentOffset(CGPoint(x: scrollViewStart, y: 0), animated: false)
            }
        }
    }
}
    
extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let numberOfItemsPerRow: CGFloat = 2
        let spacing: CGFloat = 10
        let availableWidth = width - spacing * (numberOfItemsPerRow + 1)
        let itemDimension = floor(availableWidth / numberOfItemsPerRow)
        return CGSize(width: itemDimension, height: 35)
    }
}

// MARK: - Scrollview Delegate Extension
extension ProfileViewController: UIScrollViewDelegate {
    
    /// scrollView 스크롤 시 indicator 바가 함께 움직이도록 하는 메서드
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = UIScreen.main.bounds.width
        let offsetX = scrollView.contentOffset.x
        
        self.indicatorView.snp.remakeConstraints {
            $0.top.equalTo(self.tapBarCollectionView.snp.bottom)
            $0.height.equalTo(2)
            $0.centerX.equalTo(offsetX/2 + width/4)
            $0.width.equalTo(width/6)
        }
        
        UIView.animate(
            withDuration: 0.1,
            animations: { self.view.layoutIfNeeded() }
        )
    }
}
