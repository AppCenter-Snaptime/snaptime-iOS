//
//  AlbumDetailViewController.swift
//  Snaptime
//
//  Created by Bowon Han on 4/2/24.
//

import UIKit
import SnapKit

protocol AlbumDetailViewControllerDelegate: AnyObject {
    func presentAlbumSnap()
}

final class AlbumDetailViewController: BaseViewController {
    weak var delegate: AlbumDetailViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "최근항목"
    }
    
    private lazy var albumDetailCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 30
        layout.minimumInteritemSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SnapPreviewCollectionViewCell.self, forCellWithReuseIdentifier: SnapPreviewCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    override func setupLayouts() {
        [albumDetailCollectionView].forEach {
            view.addSubview($0)
        }
    }
    
    override func setupConstraints() {
        albumDetailCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension AlbumDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SnapPreviewCollectionViewCell.identifier,
            for: indexPath
        ) as? SnapPreviewCollectionViewCell else { return UICollectionViewCell() }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 25
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.presentAlbumSnap()
    }
}

extension AlbumDetailViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let numberOfItemsPerRow: CGFloat = 2
        let spacing: CGFloat = 20 // width spacing
        let availableWidth = width - spacing * (numberOfItemsPerRow + 1)
        let itemDimension = floor(availableWidth / numberOfItemsPerRow)
        return CGSize(width: itemDimension, height: itemDimension + 100)
    }
}
