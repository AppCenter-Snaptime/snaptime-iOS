//
//  TagListViewCell.swift
//  Snaptime
//
//  Created by Bowon Han on 2/22/24.
//

import UIKit
import SnapKit

final class TagListCollectionViewCell : UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayouts()
        self.setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private var tagImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "SnapExample")
        
        return imageView
    }()
    
    private func setupLayouts() {
        addSubview(tagImageView)
    }
    
    private func setupConstraints() {
        tagImageView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}
