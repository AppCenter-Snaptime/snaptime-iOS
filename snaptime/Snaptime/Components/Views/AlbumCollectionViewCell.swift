//
//  SnapCollectionViewCell.swift
//  snaptime
//
//  Created by 이대현 on 2/15/24.
//

import Kingfisher
import SnapKit
import UIKit

final class AlbumCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayouts()
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        snapImageView.image = UIImage()
    }
    
    private lazy var snapImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .snaptimeGray
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "2023"
        label.font = UIFont(name: SuitFont.semiBold, size: 13)
        
        return label
    }()
    
    func setupUI(_ album: Album) {
        descriptionLabel.text = album.name
        
        if let photoURL = album.photoURL {
            APIService.loadImage(data: photoURL, imageView: snapImageView)
        }
    }
    
    // MARK: - setup Layouts
    private func setupLayouts() {
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 1
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.contentView.layer.cornerRadius = 15
        self.contentView.layer.masksToBounds = true
        self.contentView.backgroundColor = .white
 
        [snapImageView,
        descriptionLabel].forEach {
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
            $0.centerY.equalTo(contentView.snp.bottom).inset(18)
        }
    }
}
