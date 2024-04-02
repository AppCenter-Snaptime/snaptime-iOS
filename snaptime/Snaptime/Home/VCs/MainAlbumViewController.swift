//
//  MainAlbumViewController.swift
//  snaptime
//
//  Created by Bowon Han on 2/1/24.
//

import Alamofire
import UIKit
import SnapKit

protocol MainAlbumViewControllerDelegate: AnyObject {
    func presentAlbumDetail()
    func presentQRReaderView()
    func presentAddSnap()
}

final class MainAlbumViewController : BaseViewController {
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
        button.addAction(UIAction { [weak self] _ in
            self?.delegate?.presentAddSnap()
        }, for: .touchUpInside)
        
        return button
    }()
    
    private lazy var mainAlbumLabel : UILabel = {
        let label = UILabel()
        label.text = "모든 앨범"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private lazy var mainAlbumCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 30
        layout.minimumInteritemSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 20, right: 20)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(SnapCollectionViewCell.self, forCellWithReuseIdentifier: "SnapCollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var addSnapFloatingButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.background.backgroundColor = .snaptimeBlue
        config.baseForegroundColor = .white
        config.cornerStyle = .capsule
        config.image = UIImage(systemName: "plus")
        button.configuration = config
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.3
        button.addAction(UIAction { [weak self] _ in
            self?.delegate?.presentQRReaderView()
        }, for: .touchUpInside)
        return button
    }()
    
    weak var delegate: MainAlbumViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: -- Fetch Data
    private func fetchAlbumList() {
        
    }
    
    // MARK: -- Layout & Constraints
    override func setupLayouts() {
        super.setupLayouts()
        [
            logoTextLabel,
            addSnapButton,
            mainAlbumLabel,
            mainAlbumCollectionView,
            addSnapFloatingButton
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
            $0.top.equalTo(mainAlbumLabel.snp.bottom).offset(10)
            $0.left.right.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        addSnapFloatingButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-30)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-30)
            $0.width.equalTo(58)
            $0.height.equalTo(58)
        }
    }
}

extension MainAlbumViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 25
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SnapCollectionViewCell.identifier,
            for: indexPath
        ) as? SnapCollectionViewCell else { return UICollectionViewCell() }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.presentAlbumDetail()
    }
}

extension MainAlbumViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let numberOfItemsPerRow: CGFloat = 2
        let spacing: CGFloat = 23
        let availableWidth = width - spacing * (numberOfItemsPerRow + 1)
        let itemDimension = floor(availableWidth / numberOfItemsPerRow)
        return CGSize(width: itemDimension, height: itemDimension + 40)
    }
}
