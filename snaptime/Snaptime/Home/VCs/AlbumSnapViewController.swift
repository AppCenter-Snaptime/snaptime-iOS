//
//  DetailAlbumViewController.swift
//  snaptime
//
//  Created by Bowon Han on 2/1/24.
//

import UIKit
import SnapKit

protocol AlbumSnapViewControllerDelegate : AnyObject {
    
}

final class AlbumSnapViewController : BaseViewController {
    weak var delegate : AlbumSnapViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewConfig()
    }
    
    private let albumDetailCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1.0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        return collectionView
    }()

    private func collectionViewConfig() {
    albumDetailCollectionView.register(AlbumDetailCollectionViewCell.self,
                            forCellWithReuseIdentifier: AlbumDetailCollectionViewCell.identifier)
    albumDetailCollectionView.delegate = self
    albumDetailCollectionView.dataSource = self
    }
    
    override func setupLayouts() {
        super.setupLayouts()
        view.addSubview(albumDetailCollectionView)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        albumDetailCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension AlbumSnapViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = albumDetailCollectionView.dequeueReusableCell(
            withReuseIdentifier: AlbumDetailCollectionViewCell.identifier,
            for: indexPath
        ) as? AlbumDetailCollectionViewCell else {
            return UICollectionViewCell()
        }
            
        cell.configReuseDateLabel(date: "2024.01.24")
        cell.configReuseSnapImage(imageURL: "")
        cell.configReuseTagButtonText(nickname: "with@Lorem")
        cell.configReuseOneLineDiaryLabel(oneLineDiary: "Lorem ipsum dolor sit amet consectetur. Vitae sed malesuada ornare enim eu sed tortor dui.")
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    // 일단 임의로 개수 설정해두었습니다.
       return 10
    }
}

extension AlbumSnapViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let heigth : CGFloat = collectionView.frame.width * 1.6
        let width : CGFloat = collectionView.frame.width - 5.0
        
        return CGSize(width: width, height: heigth)
    }
}

