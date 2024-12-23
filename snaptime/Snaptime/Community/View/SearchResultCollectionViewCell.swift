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
        label.font = UIFont(name: SuitFont.bold, size: 15)
        
        return label
    }()
    
    private let nickNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: SuitFont.semiBold, size: 10)
        label.textColor = .gray
        
        return label
    }()
    
    func configData(userInfo: UserFindByNameResDto) {
        APIService.loadImageNonToken(data: userInfo.profilePhotoURL, imageView: profileImageView)
        userNameLabel.text = userInfo.foundUserName
        nickNameLabel.text = userInfo.foundNickName
    }
    
    private func setupLayouts() {
        [profileImageView,
         userNameLabel,
         nickNameLabel].forEach {
            addSubview($0)
        }
        
        profileImageView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.bottom.equalToSuperview().inset(3)
            $0.width.equalTo(profileImageView.snp.height)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(13)
            $0.left.equalTo(profileImageView.snp.right).offset(16)
            $0.right.equalToSuperview().offset(-16)
        }
        
        nickNameLabel.snp.makeConstraints {
            $0.top.equalTo(userNameLabel.snp.bottom).offset(3)
            $0.left.equalTo(userNameLabel.snp.left)
        }
    }
}
