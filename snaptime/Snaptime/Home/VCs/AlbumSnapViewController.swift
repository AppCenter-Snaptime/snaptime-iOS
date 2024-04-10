//
//  AlbumSnapViewController.swift
//  snaptime
//
//  Created by Bowon Han on 2/1/24.
//

import UIKit
import SnapKit

protocol AlbumSnapViewControllerDelegate : AnyObject {
    func presentCommentView()
}

final class AlbumSnapViewController : BaseViewController {
    weak var delegate : AlbumSnapViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private lazy var albumDetailCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1.0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 30, right: 20)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(AlbumSnapCollectionViewCell.self,
                                forCellWithReuseIdentifier: AlbumSnapCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()

    override func setupLayouts() {
        super.setupLayouts()
        
        view.addSubview(albumDetailCollectionView)
    }
        
    override func setupConstraints() {
        super.setupConstraints()
        
        albumDetailCollectionView.snp.makeConstraints {
            $0.top.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension AlbumSnapViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = albumDetailCollectionView.dequeueReusableCell(
            withReuseIdentifier: AlbumSnapCollectionViewCell.identifier,
            for: indexPath
        ) as? AlbumSnapCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.delegate = self
        cell.configureData(date: "2024.01.24",
                           imageURL: "SnapExample",
                           nickname: "with@Lorem",
                           oneLineDiary: "Lorem ipsum dolor sit amet consectetur. Vitae sed malesuada ornare enim eu sed tortor dui.")
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return 25
    }
}

extension AlbumSnapViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.bounds.width
        let numberOfItemsPerRow: CGFloat = 1
        let spacing: CGFloat = 20
        let availableWidth = width - spacing * (numberOfItemsPerRow + 1)
        let itemDimension = floor(availableWidth / numberOfItemsPerRow)
        return CGSize(width: itemDimension, height: itemDimension+290)
    }
}

extension AlbumSnapViewController: AlbumSnapCollectionViewCellDelegate {
    func didTapCommentButton() {
        delegate?.presentCommentView()
    }
}
