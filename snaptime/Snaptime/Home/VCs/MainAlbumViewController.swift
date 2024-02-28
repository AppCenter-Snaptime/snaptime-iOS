//
//  MainAlbumViewController.swift
//  snaptime
//
//  Created by Bowon Han on 2/1/24.
//

import UIKit
import SnapKit

protocol MainAlbumNavigation : AnyObject {
    func presentMainAlbum()
    func presentDetailAlbum()
}

final class MainAlbumViewController : BaseViewController {
    weak var coordinator : MainAlbumNavigation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    init(coordinator: MainAlbumNavigation) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            self.coordinator?.presentDetailAlbum()
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
        layout.minimumLineSpacing = 30
        layout.minimumInteritemSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 20, left: 30, bottom: 20, right: 30)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(SnapCollectionViewCell.self, forCellWithReuseIdentifier: "SnapCollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
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
            $0.top.equalTo(mainAlbumLabel.snp.bottom)
            $0.left.right.equalTo(view.safeAreaLayoutGuide)
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
}

extension MainAlbumViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let numberOfItemsPerRow: CGFloat = 2
        let spacing: CGFloat = 35 // width spacing
        let availableWidth = width - spacing * (numberOfItemsPerRow + 1)
        let itemDimension = floor(availableWidth / numberOfItemsPerRow)
        return CGSize(width: itemDimension, height: itemDimension + 40)
    }
}