//
//  CommunityViewController.swift
//  snaptime
//
//  Created by Bowon Han on 2/1/24.
//

import UIKit
import SnapKit

protocol CommunityViewControllerDelegate: AnyObject {
    func presentCommunity()
    func presentNotification()
    func presentCommentVC()
}

final class CommunityViewController: BaseViewController {
    weak var delegate: CommunityViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIService.fetchCommunitySnap(pageNum: 1).performRequest { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self.contentCollectionView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .snaptimeBlue
        label.font = .systemFont(ofSize: 20)
        label.text = "커뮤니티"
        
        return label
    }()
    
    private lazy var notificationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "bell"), for: .normal)
        button.tintColor = .black
        button.addAction(UIAction { [weak self] _ in
            self?.delegate?.presentNotification()
        }, for: .touchUpInside)
        
        return button
    }()
    
    private lazy var contentCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 30
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 30, right: 20)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(SnapCollectionViewCell.self, forCellWithReuseIdentifier: SnapCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }()
    
    override func setupLayouts() {
        super.setupLayouts()
        
        [titleLabel,
         notificationButton,
         contentCollectionView].forEach {
            view.addSubview($0)
        }
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(25)
        }
        
        notificationButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-25)
            $0.width.height.equalTo(24)
        }
        
        contentCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension CommunityViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CommunitySnapManager.shared.snap.result.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SnapCollectionViewCell.identifier, for: indexPath) as? SnapCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.delegate = self
        cell.configureData(data: CommunitySnapManager.shared.snap.result[indexPath.row])
        return cell
    }
}

extension CommunityViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let numberOfItemsPerRow: CGFloat = 1
        let spacing: CGFloat = 20
        let availableWidth = width - spacing * (numberOfItemsPerRow + 1)
        let itemDimension = floor(availableWidth / numberOfItemsPerRow)
        return CGSize(width: itemDimension, height: itemDimension + 280)
    }
}

extension CommunityViewController: SnapCollectionViewCellDelegate {
    func didTapCommentButton() {
        delegate?.presentCommentVC()
    }
}
