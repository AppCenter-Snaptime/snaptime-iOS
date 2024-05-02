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
        imageView.image = UIImage(named: "SnapExample")
        return imageView
    }()
    
    private lazy var descriptionLabel : UILabel = {
        let label = UILabel()
        label.text = "2023"
        label.font = .systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    func setupUI(_ album: Album) {
        descriptionLabel.text = album.name
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayouts()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayouts() {
        self.layer.shadowColor = UIColor(hexCode: "c4c4c4").cgColor
        self.layer.shadowPath = UIBezierPath(rect: CGRect(x: self.bounds.origin.x - 1.5, y: self.bounds.origin.y + 10, width: self.bounds.width + 3, height: self.bounds.height - 7)).cgPath
        self.layer.shadowOpacity = 0.7
        self.layer.shadowRadius = 7
        self.contentView.layer.cornerRadius = 15
        self.contentView.layer.masksToBounds = true
        self.contentView.backgroundColor = .white
        
        [
            snapImageView,
            descriptionLabel
        ].forEach {
            self.contentView.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        snapImageView.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.height.equalTo(contentView.bounds.height-36)
            
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.left.equalTo(snapImageView).offset(15)
            $0.centerY.equalTo(snapImageView.snp.bottom).offset(17)
        }
    }
}
