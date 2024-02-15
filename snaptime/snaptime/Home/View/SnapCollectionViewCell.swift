//
//  SnapCollectionViewCell.swift
//  snaptime
//
//  Created by 이대현 on 2/15/24.
//

import SnapKit
import UIKit

final class SnapCollectionViewCell : UICollectionViewCell {
    private lazy var snapImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        return imageView
    }()
    
    private lazy var descriptionLabel : UILabel = {
        let label = UILabel()
        label.text = "2023"
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayouts()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayouts() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 10
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.masksToBounds = true
        self.contentView.backgroundColor = .white
        
        [
            snapImageView,
            descriptionLabel
        ].forEach {
            self.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        snapImageView.snp.makeConstraints {
            $0.left.top.right.equalTo(self.safeAreaLayoutGuide)
            $0.height.equalTo(snapImageView.snp.width)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.left.equalTo(snapImageView).offset(15)
            $0.centerY.equalTo(snapImageView.snp.bottom).offset(20)
        }
    }
}
