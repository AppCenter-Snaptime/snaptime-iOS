//
//  TagListView.swift
//  Snaptime
//
//  Created by Bowon Han on 2/22/24.
//

import UIKit
import SnapKit

/// 프로필에서의 TagListView
final class TagListView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setLayouts()
        self.setConstraints()
        self.collectionViewConfig()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let tagImageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isDirectionalLockEnabled = false

        
        return collectionView
    }()
    
    private func collectionViewConfig() {
        tagImageCollectionView.register(TagListCollectionViewCell.self,
                                forCellWithReuseIdentifier: TagListCollectionViewCell.identifier)
        tagImageCollectionView.delegate = self
        tagImageCollectionView.dataSource = self
    }
    
    private func setLayouts() {
        addSubview(tagImageCollectionView)
    }
    
    private func setConstraints() {
        tagImageCollectionView.snp.makeConstraints {
            $0.top.left.right.bottom.equalToSuperview()
        }
    }
}

extension TagListView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = tagImageCollectionView.dequeueReusableCell(
            withReuseIdentifier: TagListCollectionViewCell.identifier,
            for: indexPath
        ) as? TagListCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
}

extension TagListView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (collectionView.frame.width / 3) - 1.0
        let heigth: CGFloat = width * 1.4
        
        return CGSize(width: width, height: heigth)
    }
}
