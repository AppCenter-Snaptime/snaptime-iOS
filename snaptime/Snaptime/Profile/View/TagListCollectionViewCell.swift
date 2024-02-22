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
        self.setLayouts()
        self.setConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private var tagImageView : UIImageView = {
        let imageView = UIImageView()
//        imageView.backgroundColor = .snaptimeGray
        imageView.image = UIImage(named: "SnapExample")

        
        return imageView
    }()
    
    private func setLayouts() {
        addSubview(tagImageView)
    }
    
    private func setConstraints() {
        tagImageView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}
