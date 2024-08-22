//
//  NotificationViewController.swift
//  Snaptime
//
//  Created by Bowon Han on 3/18/24.
//

import UIKit
import SnapKit

protocol NotificationViewControllerDelegate: AnyObject {
    func presentNotification()
}

final class NotificationViewController: BaseViewController {
    weak var delegate: NotificationViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
    }
    
    private lazy var topTextLabel: UILabel = {
        let label = UILabel()
        label.text = "알림"
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textColor = UIColor.init(hexCode: "003E6E")
        
        return label
    }()
    
    private lazy var topBackButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = .black
        
        return button
    }()
    
    private lazy var notificationCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(NotificationCollectionViewCell.self, 
                                forCellWithReuseIdentifier: NotificationCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    private func setupNavigationBar() {
        self.showNavigationBar()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: topTextLabel)
    }
    
    override func setupLayouts() {
        super.setupLayouts()
        
        [notificationCollectionView].forEach {
            view.addSubview($0)
        }
        
        notificationCollectionView.snp.makeConstraints {
            $0.top.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension NotificationViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = notificationCollectionView.dequeueReusableCell(
            withReuseIdentifier: NotificationCollectionViewCell.identifier,
            for: indexPath) as? NotificationCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        
        return cell
    }
}

extension NotificationViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        /// 수정필요
        let height: CGFloat = 86
        let width : CGFloat = collectionView.frame.width
        
        return CGSize(width: width, height: height)
    }
}
