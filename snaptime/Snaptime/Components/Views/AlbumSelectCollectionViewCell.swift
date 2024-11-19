//
//  AlbumSelectCollectionViewCell.swift
//  Snaptime
//
//  Created by 이대현 on 7/31/24.
//

import Kingfisher
import SnapKit
import UIKit

final class AlbumSelectCollectionViewCell: UICollectionViewCell {
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
    
    private lazy var descriptionLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: SuitFont.semiBold, size: 13)
        
        return label
    }()
    
    private lazy var checkImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    func setupUI(_ album: Album) {
        descriptionLabel.text = album.name
        
        if let photoURL = album.photoURL {
            APIService.loadImage(data: photoURL, imageView: snapImageView)
        }
    }
    
    private var checked: Bool = false {
        didSet {
            if checked == true {
                self.checkImageView.image = UIImage(systemName: "checkmark.circle.fill")
                self.checkImageView.tintColor = .white
            } else {
                self.checkImageView.image = UIImage(systemName: "circle")
                self.checkImageView.tintColor = .white
            }
        }
    }
    
    func check(_ isCheck : Bool = true) {
        checked = isCheck
    }
    
    // MARK: - setup Layouts
    private func setupLayouts() {
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowPath = UIBezierPath(rect: CGRect(x: self.bounds.origin.x - 1.5, y: self.bounds.origin.y + 10, width: self.bounds.width + 3, height: self.bounds.height - 7)).cgPath
        self.layer.shadowOpacity = 0.7
        self.layer.shadowRadius = 7
        self.contentView.layer.cornerRadius = 15
        self.contentView.layer.masksToBounds = true
        self.contentView.backgroundColor = .white
 
        [snapImageView,
        descriptionLabel,
        checkImageView].forEach {
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
            $0.centerY.equalTo(contentView.snp.bottom).offset(-17)
        }
        
        checkImageView.snp.makeConstraints {
            $0.left.top.equalToSuperview().offset(16)
            $0.width.height.equalTo(24)
        }
    }
}
