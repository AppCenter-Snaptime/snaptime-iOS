//
//  TagListView.swift
//  Snaptime
//
//  Created by Bowon Han on 2/22/24.
//

import UIKit
import SnapKit

final class TagListView : UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setLayouts()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let tagImageCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        
        return collectionView
    }()
    
    private func collectionViewConfig() {
        tagImageCollectionView.register(AlbumDetailCollectionViewCell.self,
                                forCellWithReuseIdentifier: AlbumDetailCollectionViewCell.identifier)
        tagImageCollectionView.delegate = self
        tagImageCollectionView.dataSource = self
    }
    
    private func setLayouts() {
        addSubview(tagImageCollectionView)
    }
    
    private func setConstraints() {
        tagImageCollectionView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
    }
}

extension TagListView : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = tagImageCollectionView.dequeueReusableCell(
            withReuseIdentifier: AlbumDetailCollectionViewCell.identifier,
            for: indexPath
        ) as? AlbumDetailCollectionViewCell else {
            return UICollectionViewCell()
        }
    }
}
