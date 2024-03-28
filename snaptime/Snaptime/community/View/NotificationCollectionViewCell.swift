//
//  NotificationCollectionViewCell.swift
//  Snaptime
//
//  Created by Bowon Han on 3/21/24.
//

import UIKit
import SnapKit

final class NotificationCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private lazy var notificationView = CommentView()
    
    private lazy var previewImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "SnapExample")

        return imageView
    }()
    
    
    private func setupLayout() {
        [notificationView,
         previewImage].forEach {
            addSubview($0)
        }

        notificationView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(14)
            $0.bottom.equalToSuperview().offset(-14)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalTo(previewImage.snp.left).offset(-15)
        }

        previewImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(14)
            $0.bottom.equalToSuperview().offset(-14)
            $0.right.equalToSuperview().offset(-20)
            $0.width.equalTo(49)
        }
    }
}
