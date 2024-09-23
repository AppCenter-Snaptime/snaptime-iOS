//
//  CommunityViewController.swift
//  snaptime
//
//  Created by Bowon Han on 2/1/24.
//

import UIKit
import SnapKit

protocol CommunityViewControllerDelegate: AnyObject {
    func presentCommunity()
    func presentNotification()
    func presentCommentVC(snap: FindSnapResDto)
    func presentSearch() 
    func presentProfile(target: ProfileTarget, loginId: String)
    func presentTag(tagList: [FindTagUserResDto])
}

final class CommunityViewController: BaseViewController {
    weak var delegate: CommunityViewControllerDelegate?
    
    private var snaps: [FindSnapResDto] = []
    private var hasNextPage: Bool = false
    private var pageNum: Int = 1
    private var isInfiniteScroll: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        pageNum = 1
        hasNextPage = false
        isInfiniteScroll = true
        self.fetchSnaps(pageNum: pageNum) {}
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .snaptimeBlue
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.text = "Community"
        
        return label
    }()
    
    private lazy var findUserButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .clear
        config.baseForegroundColor = .black
        config.image = UIImage(systemName: "magnifyingglass")
        button.configuration = config
        button.addAction(UIAction{ [weak self] _ in
            self?.delegate?.presentSearch()
        }, for: .touchUpInside)
        
        return button
    }()
    
    private lazy var alertButton: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.borderedTinted()
        
        var titleAttr = AttributedString.init("볼 수 있는 스냅이 없습니다! \n 사용자를 팔로우하세요!")
        titleAttr.font = .systemFont(ofSize: 14, weight: .semibold)
        
        config.attributedTitle = titleAttr
        config.imagePlacement = .leading
        config.imagePadding = 8
        config.image = UIImage(systemName: "magnifyingglass")
        config.cornerStyle = .large
        config.baseForegroundColor = .black
        config.baseBackgroundColor = .white
        config.background.strokeWidth = 1
        config.background.strokeColor = .snaptimeGray
        button.configuration = config

        button.addAction(UIAction { [weak self] _ in
            self?.delegate?.presentSearch()
        }, for: .touchUpInside)
        
        return button
    }()
    
    private lazy var contentCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 30
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 30, right: 20)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(SnapCollectionViewCell.self,
                                forCellWithReuseIdentifier: SnapCollectionViewCell.identifier)
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        return collectionView
    }()
    
    private func fetchSnaps(pageNum: Int, completion: @escaping (() -> ())) {
        LoadingService.showLoading()
        APIService.fetchCommunitySnap(pageNum: pageNum).performRequest(responseType: CommonResponseDtoListFindSnapPagingResDto.self) { result in
            switch result {
            case .success(let snap):
                DispatchQueue.main.async {
                    self.alertButton.isHidden = true
                    self.contentCollectionView.isHidden = false
                    if pageNum == 1 {
                        self.snaps = snap.result.snapDetailInfoResDtos
                    }
                    else {
                        self.snaps.append(contentsOf: snap.result.snapDetailInfoResDtos)
                    }
                    
                    self.contentCollectionView.reloadData()
                    self.hasNextPage = snap.result.hasNextPage
                    
                    if self.hasNextPage {
                        self.pageNum += 1
                    }
                }
            case .failure(let error):
                self.contentCollectionView.isHidden = true
                self.alertButton.isHidden = false
                print(error)
            }
            
            completion()
            LoadingService.hideLoading()
        }
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: UIImageView(image: UIImage(named: "HeaderLogo")))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: findUserButton)
    }
    
    override func setupLayouts() {
        super.setupLayouts()
        
        [contentCollectionView,
         alertButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func setupConstraints() {
        super.setupConstraints()

        alertButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.left.right.equalTo(view.safeAreaLayoutGuide).inset(50)
            $0.height.equalTo(60)
        }

        contentCollectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension CommunityViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return snaps.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SnapCollectionViewCell.identifier,
            for: indexPath
        ) as? SnapCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.delegate = self
        
        var profileTarget: ProfileTarget = .others
        let tagList = self.snaps[indexPath.row].tagUserFindResDtos
        
        cell.profileTapAction = {
            if self.snaps[indexPath.row].writerLoginId == ProfileBasicUserDefaults().loginId {
                profileTarget = .myself
            }
            
            self.delegate?.presentProfile(
                target: profileTarget,
                loginId: self.snaps[indexPath.row].writerLoginId
            )
        }
        
        cell.tagButtonTapAction = {
            if !tagList.isEmpty {
                self.delegate?.presentTag(tagList: tagList)
            }
        }
                
        cell.configureData(data: self.snaps[indexPath.row], editButtonToggle: false)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    /// 남은 content size 의 높이보다 스크롤을 많이 했다. 즉, 다음 컨텐츠가 필요한 경우.
        if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.height {
            if isInfiniteScroll && hasNextPage {
                isInfiniteScroll = false
                
                fetchSnaps(pageNum: pageNum) {
                    self.isInfiniteScroll = true
                }
            }
        }
    }
}

extension CommunityViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let numberOfItemsPerRow: CGFloat = 1
        let spacing: CGFloat = 20
        let availableWidth = width - spacing * (numberOfItemsPerRow + 1)
        let itemDimension = floor(availableWidth / numberOfItemsPerRow)
        return CGSize(width: itemDimension, height: itemDimension + 280)
    }
}

extension CommunityViewController: SnapCollectionViewCellDelegate {
    func didTapEditButton(snap: FindSnapResDto) {}
    
    func didTapCommentButton(snap: FindSnapResDto) {
        // TODO: snap id 추가하기
        delegate?.presentCommentVC(snap: snap)
    }
}
