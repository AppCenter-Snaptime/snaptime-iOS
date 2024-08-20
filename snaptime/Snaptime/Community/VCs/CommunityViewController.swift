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
        self.fetchSnaps(pageNum: pageNum) {}
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
    
    private lazy var contentCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 30
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 30, right: 20)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(SnapCollectionViewCell.self, forCellWithReuseIdentifier: SnapCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }()
    
    private func fetchSnaps(pageNum: Int, completion: @escaping (() -> ())) {
        APIService.fetchCommunitySnap(pageNum: pageNum).performRequest(responseType: CommonResponseDtoListFindSnapPagingResDto.self) { result in
            switch result {
            case .success(let snap):
                DispatchQueue.main.async {
                    self.snaps.append(contentsOf: snap.result.snapDetailInfoResDtos)
                    self.hasNextPage = snap.result.hasNextPage
                    self.pageNum += 1
                    self.contentCollectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: UIImageView(image: UIImage(named: "HeaderLogo")))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: findUserButton)
    }
    
    override func setupLayouts() {
        super.setupLayouts()
        
        [contentCollectionView].forEach {
            view.addSubview($0)
        }
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        contentCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension CommunityViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return snaps.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SnapCollectionViewCell.identifier, for: indexPath) as? SnapCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.delegate = self
        cell.configureData(data: self.snaps[indexPath.row])
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
    func didTapCommentButton(snap: FindSnapResDto) {
        // TODO: snap id 추가하기
        delegate?.presentCommentVC(snap: snap)
    }
    
    func didTapEditButton(snap: FindSnapResDto) {
        // NOTE: 이후 작업 해야함!
//        // ActionSheet 관련 설정
//        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        actionSheet.addAction(UIAlertAction(title: "수정하기", style: .default, handler: { _ in
//            //            self.presentAddAlbumPopup()
//        }))
//        actionSheet.addAction(UIAlertAction(title: "폴더 이동", style: .default, handler: { _ in
//            //            self.presentAddAlbumPopup()
//        }))
//        actionSheet.addAction(UIAlertAction(title: "삭제하기", style: .destructive, handler: { _ in
//            //            self.delegate?.presentAlbumDelete()
//        }))
//        actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel))
//        
//        self.present(actionSheet, animated: true)
    }
}
