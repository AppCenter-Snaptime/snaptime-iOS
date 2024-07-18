//
//  AlbumListView.swift
//  Snaptime
//
//  Created by Bowon Han on 2/22/24.
//

import UIKit
import SnapKit

/// 프로필에서의 AlbumListView
final class AlbumListView: UIView {
    var send: ((Int) -> Void)?
    private var albumList: [AlbumSnapResDto] = []
    private var loginId: String = ""

    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.setLayouts()
        self.setConstraints()
        self.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var profileAlbumListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 30
        layout.sectionInset = UIEdgeInsets(top: 20, left: 30, bottom: 20, right: 30)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isDirectionalLockEnabled = false
        collectionView.register(AlbumListCollectionViewCell.self, forCellWithReuseIdentifier: AlbumListCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }()
    
    func reloadData() {
        self.profileAlbumListCollectionView.reloadData()
    }
    
    func setLoginId(loginId: String) {
        self.fetchUserAlbum(loginId: loginId)
        self.reloadData()
    }
    
    private func fetchUserAlbum(loginId: String) {
        APIService.fetchUserAlbum(loginId: loginId).performRequest { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let result):
                    if let result = result as? CommonResponseDtoListAlbumSnapResDto {
                        self.albumList = result.result
                        self.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    // MARK: - set Layouts
    private func setLayouts() {
        addSubview(profileAlbumListCollectionView)
    }
    
    private func setConstraints() {
        profileAlbumListCollectionView.snp.makeConstraints {
            $0.top.left.right.bottom.equalToSuperview()
        }
    }
}

extension AlbumListView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = profileAlbumListCollectionView.dequeueReusableCell(
            withReuseIdentifier: AlbumListCollectionViewCell.identifier,
            for: indexPath
        ) as? AlbumListCollectionViewCell else {
            return UICollectionViewCell()
        }
                
        cell.setCellData(data: self.albumList[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let flow = self.send {
            flow(albumList[indexPath.row].albumId)
        }
    }
}

extension AlbumListView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let numberOfItemsPerRow: CGFloat = 1
        let spacing: CGFloat = 30
        let availableWidth = width - spacing * (numberOfItemsPerRow + 1)
        let itemDimension = floor(availableWidth / numberOfItemsPerRow)
        
        return CGSize(width: itemDimension, height: itemDimension * 215/345)
    }
}
