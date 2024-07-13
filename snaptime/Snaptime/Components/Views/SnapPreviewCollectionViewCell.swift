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
        return imageView
    }()
    
    private lazy var descriptionLabel : UILabel = {
        let label = UILabel()
        label.text = "2023"
        label.font = .systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    private lazy var date: UILabel = {
        let label = UILabel()
        label.text = "2024.01.20"
        label.font = .systemFont(ofSize: 10, weight: .light)
        label.textColor = UIColor.init(hexCode: "#A9A9A9")
        
        return label
    }()
    
    func setupUI(_ snapPreiviews: FindSnapResDto) {
        descriptionLabel.text = snapPreiviews.oneLineJournal
        if let url = URL(string: snapPreiviews.snapPhotoURL) {
            let modifier = AnyModifier { request in
                var r = request
                r.setValue("*/*", forHTTPHeaderField: "accept")
                r.setValue(ACCESS_TOKEN, forHTTPHeaderField: "Authorization")
                return r
            }
            
            snapImageView.kf.setImage(with: url, options: [.requestModifier(modifier)]) { result in
                switch result {
                case .success(_):
                    print("success fetch image")
                case .failure(let error):
                    print("error")
                    print(error)
                }
            }
        }
    }
    
    // MARK: - setup Layouts
    private func setupLayouts() {
        self.layer.shadowColor = UIColor(hexCode: "c4c4c4").cgColor
        self.layer.shadowPath = UIBezierPath(rect: CGRect(x: self.bounds.origin.x - 1.5, y: self.bounds.origin.y + 10, width: self.bounds.width + 3, height: self.bounds.height - 7)).cgPath
        self.layer.shadowOpacity = 0.7
        self.layer.shadowRadius = 7
        self.contentView.layer.cornerRadius = 15
        self.contentView.layer.masksToBounds = true
        self.contentView.backgroundColor = .white
        
        [snapImageView,
         descriptionLabel,
         date].forEach {
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
        
        date.snp.makeConstraints {
            $0.right.equalTo(snapImageView).offset(-15)
            $0.bottom.equalToSuperview().offset(-3)
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(5)
        }
    }
}
