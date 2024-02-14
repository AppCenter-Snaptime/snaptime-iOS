//
//  DetailAlbumViewController.swift
//  snaptime
//
//  Created by Bowon Han on 2/1/24.
//

import UIKit
import SnapKit

protocol DetailAlbumNavigation : AnyObject {

}

final class DetailAlbumViewController : BaseViewController {
    weak var coordinator : DetailAlbumNavigation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewConfig()
    }
    
    init(coordinator: DetailAlbumNavigation) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let albumDetailCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10.0
        layout.minimumLineSpacing = 10.0

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
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension DetailAlbumViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = albumDetailCollectionView.dequeueReusableCell(
            withReuseIdentifier: AlbumDetailCollectionViewCell.identifier,
            for: indexPath
        ) as? AlbumDetailCollectionViewCell else {
            return UICollectionViewCell()
        }
            
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
}

extension DetailAlbumViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let heigth : CGFloat = collectionView.frame.width * 1.6
        let width : CGFloat = collectionView.frame.width - 5.0
        
        return CGSize(width: width, height: heigth)
    }
}

