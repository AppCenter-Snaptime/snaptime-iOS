//
//  SnapViewController.swift
//  Snaptime
//
//  Created by Bowon Han on 6/21/24.
//

import UIKit
import SnapKit
import Alamofire

protocol SnapViewControllerDelegate: AnyObject {
    func presentCommentVC(snap: FindSnapResDto)
    func presentEditSnapVC(snap: FindSnapResDto)
    func presentMoveAlbumVC(snap: FindSnapResDto)
    func presentProfile(target: ProfileTarget, email: String)
    func backToPrevious()
    func backToRoot()
    func presentTag(tagList: [FindTagUserResDto])
}

final class SnapViewController: BaseViewController {
    weak var delegate: SnapViewControllerDelegate?
    private let snapId: Int
    private let profileTarget: ProfileTarget
    
    private var snap: FindSnapResDto = FindSnapResDto(
        snapId: 0,
        oneLineJournal: "",
        snapPhotoURL: "",
        snapCreatedDate: "",
        snapModifiedDate: "",
        writerEmail: "",
        profilePhotoURL: "",
        writerUserName: "",
        tagUserFindResDtos: [],
        likeCnt: 0,
        isLikedSnap: false
    )
    
    init(snapId: Int, profileType: ProfileTarget) {
        self.snapId = snapId
        self.profileTarget = profileType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchSnap(id: self.snapId)
    }
    
    private func fetchSnap(id: Int) {
        APIService.fetchSnap(albumId: id).performRequest(responseType: CommonResponseDtoFindSnapResDto.self) { result in
            switch result {
            case .success(let snap):
                DispatchQueue.main.async {
                    self.snap = snap.result
                    self.snapCollectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func deleteSnap(id: Int) {
        APIService.deleteSnap(snapId: self.snapId).performRequest(responseType: CommonResDtoVoid.self) { result in
            switch result {
            case .success(_):
                print("Snap 삭제 성공!")
            case .failure(let error):
                print(error.localizedDescription)
                print(error)
            }
        }
    }
    
    private lazy var snapCollectionView: UICollectionView = {
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

    override func setupLayouts() {
        super.setupLayouts()
        
        view.addSubview(snapCollectionView)
    }
        
    override func setupConstraints() {
        super.setupConstraints()
        
        snapCollectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - extension
extension SnapViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = snapCollectionView.dequeueReusableCell(
            withReuseIdentifier: SnapCollectionViewCell.identifier,
            for: indexPath
        ) as? SnapCollectionViewCell else {
            return UICollectionViewCell()
        }

        var profileTarget: ProfileTarget = .others
        
        if self.snap.writerEmail == ProfileBasicUserDefaults().email {
            profileTarget = .myself
        }
        
        cell.delegate = self
        cell.profileTapAction = {
            self.delegate?.presentProfile(target: profileTarget, email: self.snap.writerEmail)
        }
        
        if !self.snap.tagUserFindResDtos.isEmpty {
            cell.tagButtonTapAction = {
                self.delegate?.presentTag(tagList: self.snap.tagUserFindResDtos)
            }
        }
        
        switch profileTarget {
        case .myself:
            cell.configureData(data: self.snap)
        case .others:
            cell.configureData(data: self.snap, editButtonToggle: false)
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
}

extension SnapViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.window?.screen.bounds.width ?? .zero
        let numberOfItemsPerRow: CGFloat = 1
        let spacing: CGFloat = 20
        let availableWidth = width - spacing * (numberOfItemsPerRow + 1)
        let itemDimension = floor(availableWidth / numberOfItemsPerRow)
        return CGSize(width: itemDimension, height: itemDimension+300)
    }
}

extension SnapViewController: SnapCollectionViewCellDelegate {
    func didTapCommentButton(snap: FindSnapResDto) {
        delegate?.presentCommentVC(snap: snap)
    }
    
    func didTapEditButton(snap: FindSnapResDto) {
        // ActionSheet 관련 설정
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "수정하기", style: .default, handler: { _ in
            self.delegate?.presentEditSnapVC(snap: snap)
        }))
        actionSheet.addAction(UIAlertAction(title: "폴더 이동", style: .default, handler: { _ in
            self.delegate?.presentMoveAlbumVC(snap: snap)
        }))
        actionSheet.addAction(UIAlertAction(title: "삭제하기", style: .destructive, handler: { _ in
            // NOTE: 추가로 삭제 확인할 팝업 달아도 좋을 듯
            self.deleteSnap(id: self.snapId)
            self.delegate?.backToRoot()
        }))
        actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        self.present(actionSheet, animated: true)
    }
}
