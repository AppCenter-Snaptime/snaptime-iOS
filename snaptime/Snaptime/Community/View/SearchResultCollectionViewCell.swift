//
//  SearchResultCollectionViewCell.swift
//  Snaptime
//
//  Created by Bowon Han on 8/5/24.
//

import UIKit
import SnapKit

final class SearchResultCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.layer.masksToBounds = true
    }
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .snaptimeGray
        
        return imageView
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.text = "한보원"
        
        return label
    }()
    
    func configData(userInfo: UserFindByNameResDto) {
        APIService.loadImageNonToken(data: userInfo.profilePhotoURL, imageView: profileImageView)
        self.userNameLabel.text = userInfo.foundUserName
    }
    
    private func setupLayouts() {
        [profileImageView,
         userNameLabel].forEach {
            addSubview($0)
        }
        
        profileImageView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.bottom.equalToSuperview().inset(3)
            $0.width.equalTo(profileImageView.snp.height)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView.snp.centerY)
            $0.left.equalTo(profileImageView.snp.right).offset(16)
            $0.right.equalToSuperview().offset(-16)
        }
    }
}
