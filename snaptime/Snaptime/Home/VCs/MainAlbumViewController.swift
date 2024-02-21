//
//  MainAlbumViewController.swift
//  snaptime
//
//  Created by Bowon Han on 2/1/24.
//

import UIKit
import SnapKit

protocol MainAlbumViewControllerDelegate: AnyObject {
    func presentDetailView()
}

final class MainAlbumViewController : BaseViewController {
    weak var delegate : MainAlbumViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(delegate)
    }
    
    private let logoTextLabel : UILabel = {
        let label = UILabel()
        label.text = "SnapTime"
        
        return label
    }()
    
    private lazy var addSnapButton : UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "plus")
        config.baseBackgroundColor = .systemBackground
        config.baseForegroundColor = .black
        button.configuration = config
        button.addAction(UIAction { _ in
            self.delegate?.presentDetailView()
        }, for: .touchUpInside)
        
        return button
    }()
    
    private lazy var mainAlbumLabel : UILabel = {
        let label = UILabel()
        label.text = "모든 앨범"
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var mainAlbumCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(SnapCollectionViewCell.self, forCellWithReuseIdentifier: "SnapCollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    
    private func loadCollectionView() {
        
    }
    
    override func setupLayouts() {
        super.setupLayouts()
        [
            logoTextLabel,
            addSnapButton,
            mainAlbumLabel,
            mainAlbumCollectionView
        ].forEach {
            view.addSubview($0)
        }
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        logoTextLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(13)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        addSnapButton.snp.makeConstraints {
            $0.centerY.equalTo(logoTextLabel.snp.centerY)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
        mainAlbumLabel.snp.makeConstraints {
            $0.top.equalTo(logoTextLabel.snp.bottom).offset(30)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
        mainAlbumCollectionView.snp.makeConstraints {
            $0.top.equalTo(mainAlbumLabel.snp.bottom).offset(20)
            $0.left.right.equalTo(mainAlbumLabel)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-30)
        }
    }
}

extension MainAlbumViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 25
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "SnapCollectionViewCell",
            for: indexPath
        ) as? SnapCollectionViewCell else { return UICollectionViewCell() }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSelectItemAt")
        print(delegate)
        delegate?.presentDetailView()
    }
}

extension MainAlbumViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let numberOfItemsPerRow: CGFloat = 2
        let spacing: CGFloat = 18 // width spacing
        let availableWidth = width - spacing * (numberOfItemsPerRow + 1)
        let itemDimension = floor(availableWidth / numberOfItemsPerRow)
        return CGSize(width: itemDimension, height: itemDimension + 40)
    }
}
