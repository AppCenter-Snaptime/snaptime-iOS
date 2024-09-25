//
//  TagListCollectionViewCell.swift
//  Snaptime
//
//  Created by Bowon Han on 4/2/24.
//

import UIKit
import SnapKit

final class AddTagListCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        profileImage.layer.cornerRadius = profileImage.frame.height/2
    }
    
    private lazy var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .snaptimeGray
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        
        return label
    }()
    
    private let nickNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .semibold)
        label.textColor = .gray
        label.text = "bowon0000"
        
        return label
    }()
    
    func setupUI(info: FriendInfo) {
        userNameLabel.text = info.foundUserName
        APIService.loadImage(data: info.profilePhotoURL, imageView: profileImage)
    }
    
    private func setupLayouts() {
        [profileImage,
         userNameLabel,
         nickNameLabel].forEach {
            addSubview($0)
        }
        
        profileImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
            $0.height.equalTo(35)
            $0.width.equalTo(35)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(13)
            $0.left.equalTo(profileImage.snp.right).offset(15)
        }
        
        nickNameLabel.snp.makeConstraints {
            $0.top.equalTo(userNameLabel.snp.bottom).offset(3)
            $0.left.equalTo(userNameLabel.snp.left)
        }
    }
}
