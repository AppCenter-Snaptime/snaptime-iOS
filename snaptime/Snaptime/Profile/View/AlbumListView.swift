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
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setLayouts()
        self.setConstraints()
        self.collectionViewConfig()
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
        
        return collectionView
    }()
    
    private func collectionViewConfig() {
        profileAlbumListCollectionView.register(AlbumListCollectionViewCell.self, forCellWithReuseIdentifier: AlbumListCollectionViewCell.identifier)
        profileAlbumListCollectionView.dataSource = self
        profileAlbumListCollectionView.delegate = self
    }
    
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
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
}

extension AlbumListView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let numberOfItemsPerRow: CGFloat = 1
        let spacing: CGFloat = 30
        let availableWidth = width - spacing * (numberOfItemsPerRow + 1)
        let itemDimension = floor(availableWidth / numberOfItemsPerRow)
        
        return CGSize(width: itemDimension, height: itemDimension * 216/343)
    }
}
