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
    
    private lazy var snapImageView: UIImageView = {
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
    
    private lazy var date: UILabel = {
        let label = UILabel()
        label.text = "2024.01.20"
        label.font = .systemFont(ofSize: 10, weight: .light)
        label.textColor = UIColor.init(hexCode: "#A9A9A9")
        
        return label
    }()
    
    func setupUI(_ album: Album) {
        descriptionLabel.text = album.name
        if let photoURL = album.photoURL,
           let url = URL(string: photoURL) {
            let modifier = AnyModifier { request in
                var r = request
                r.setValue("*/*", forHTTPHeaderField: "accept")
                r.setValue(ACCESS_TOKEN, forHTTPHeaderField: "Authorization")
                return r
            }
            
            snapImageView.kf.setImage(with: url, options: [.requestModifier(modifier)]) { result in
                switch result {
                case .success(_):
                    print("success")
                case .failure(let error):
                    print("error")
                    print(error)
                }
            }
        }
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
            $0.centerY.equalTo(snapImageView.snp.bottom).offset(17)
        }
    }
}
