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
    
    private lazy var nickNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "blwxnhan"
        
        return label
    }()
    
    private func setupLayouts() {
        [profileImage,
         nickNameLabel].forEach {
            addSubview($0)
        }
        
        profileImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
            $0.height.equalTo(32)
            $0.width.equalTo(32)
        }
        
        nickNameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(profileImage.snp.right).offset(15)
        }
    }
}
