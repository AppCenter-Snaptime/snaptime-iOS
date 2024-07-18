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
    private var tagList: [ProfileTagSnapResDto] = []
    private var loginId: String = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setLayouts()
        self.setConstraints()
        self.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var tagImageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isDirectionalLockEnabled = false
        collectionView.register(TagListCollectionViewCell.self,
                                forCellWithReuseIdentifier: TagListCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    func reloadData() {
        self.tagImageCollectionView.reloadData()
    }
    
    func setLoginId(loginId: String) {
        self.fetchTagList(loginId: loginId)
        self.reloadData()
    }
    
    private func fetchTagList(loginId: String) {
        APIService.fetchUserTagSnap(loginId: loginId).performRequest { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let result):
                    if let result = result as? CommonResponseDtoListProfileTagSnapResDto {
                        self.tagList = result.result
                        self.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
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
        
        cell.setCellData(data: self.tagList[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagList.count
    }
}

extension TagListView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (collectionView.frame.width / 3) - 1.0
        let heigth: CGFloat = width * 1.4
        
        return CGSize(width: width, height: heigth)
    }
}
