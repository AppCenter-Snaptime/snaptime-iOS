//
//  AlbumPreviewCollectionViewCell.swift
//  Snaptime
//
//  Created by Bowon Han on 5/25/24.
//

import Kingfisher
import SnapKit
import UIKit

final class SnapPreviewCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayouts()
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        label.font = UIFont(name: SuitFont.regular, size: 12)
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: SuitFont.light, size: 10)
        label.textColor = UIColor.init(hexCode: "#A9A9A9")
        
        return label
    }()
    
    func setupUI(_ snapPreiviews: FindSnapPreviewResDto) {
        descriptionLabel.text = snapPreiviews.oneLineJournal
        dateLabel.text = snapPreiviews.snapCreatedDate.toDateString()
        APIService.loadImage(data: snapPreiviews.snapPhotoURL, imageView: snapImageView)
    }
    
    // MARK: - setup Layouts
    private func setupLayouts() {
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 2
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.contentView.layer.cornerRadius = 15
        self.contentView.layer.masksToBounds = true
        self.contentView.backgroundColor = .white
        
        [snapImageView,
         descriptionLabel,
         dateLabel].forEach {
            self.contentView.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        snapImageView.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.height.equalTo(contentView.bounds.height-50)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.left.equalTo(snapImageView).offset(15)
            $0.top.equalTo(snapImageView.snp.bottom).offset(10)
            $0.right.equalTo(snapImageView).offset(-15)
        }
        
        dateLabel.snp.makeConstraints {
            $0.right.equalTo(snapImageView).offset(-15)
            $0.bottom.equalToSuperview().offset(-3)
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(5)
        }
    }
}
