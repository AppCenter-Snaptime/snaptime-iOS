//
//  AlbumSnapViewController.swift
//  snaptime
//
//  Created by Bowon Han on 2/1/24.
//

import UIKit
import SnapKit

protocol SnapListViewControllerDelegate: AnyObject {
    func presentCommentVC()
}

final class SnapListViewController: BaseViewController {
    weak var delegate : SnapListViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private lazy var snapCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 30
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 30, right: 20)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(SnapCollectionViewCell.self,
                                forCellWithReuseIdentifier: SnapCollectionViewCell.identifier)
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
            $0.top.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension SnapListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = snapCollectionView.dequeueReusableCell(
            withReuseIdentifier: SnapCollectionViewCell.identifier,
            for: indexPath
        ) as? SnapCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.delegate = self
//        cell.configureData(profileImageURL: "SnapExample", name: "Jocelyn", tagList: "Lorem", postImageURL: "SnapExample", postContent: "Lorem ipsum dolor sit amet consectetur. Vitae sed malesuada ornare enim eu sed tortor dui.", date: "2024.01.24")
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return 25
    }
}

extension SnapListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.bounds.width
        let numberOfItemsPerRow: CGFloat = 1
        let spacing: CGFloat = 20
        let availableWidth = width - spacing * (numberOfItemsPerRow + 1)
        let itemDimension = floor(availableWidth / numberOfItemsPerRow)
        return CGSize(width: itemDimension, height: itemDimension+300)
    }
}

extension SnapListViewController: SnapCollectionViewCellDelegate {
    func didTapCommentButton() {
        delegate?.presentCommentVC()
    }
}
