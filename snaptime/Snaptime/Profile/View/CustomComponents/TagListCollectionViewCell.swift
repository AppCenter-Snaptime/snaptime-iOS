//
//  TagListViewCell.swift
//  Snaptime
//
//  Created by Bowon Han on 2/22/24.
//

import UIKit
import SnapKit
import Kingfisher

/// TagList내부 collectionview의 Custom Cell 
final class TagListCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayouts()
        self.setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private var tagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "SnapExample")
        
        return imageView
    }()
    
    func setCellData(data: ProfileTagSnapResDto) {
        loadImage(data: data.taggedSnapUrl, imageView: self.tagImageView)
    }
    
    private func loadImage(data: String, imageView: UIImageView) {
        if let url = URL(string: data) {
            let modifier = AnyModifier { request in
                var r = request
                r.setValue("*/*", forHTTPHeaderField: "accept")
                r.setValue(ACCESS_TOKEN, forHTTPHeaderField: "Authorization")
                return r
            }
            
            imageView.kf.setImage(with: url, options: [.requestModifier(modifier)]) { result in
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
    
    private func setupLayouts() {
        addSubview(tagImageView)
    }
    
    private func setupConstraints() {
        tagImageView.snp.makeConstraints {
            $0.top.right.left.bottom.equalToSuperview()
        }
    }
}
