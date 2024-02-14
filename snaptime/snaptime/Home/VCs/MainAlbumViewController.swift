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
    
    private lazy var mainAlbumCollectionView : UICollectionView = {
        let collectionView = UICollectionView()
        collectionView.backgroundColor = .red
        return collectionView
    }()
    
    override func setupLayouts() {
        super.setupLayouts()
        [
            logoTextLabel,
            addSnapButton,
            mainAlbumCollectionView
        ].forEach {
            view.addSubview($0)
        }
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        logoTextLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(70)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(30)
        }
        
        addSnapButton.snp.makeConstraints {
            $0.centerY.equalTo(logoTextLabel.snp.centerY)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-30)
        }
    }
}

