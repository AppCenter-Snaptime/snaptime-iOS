//
//  TopTapBarCollectionViewCell.swift
//  Snaptime
//
//  Created by Bowon Han on 3/1/24.
//

import UIKit
import SnapKit

final class TopTapBarCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let tapButtonTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: SuitFont.medium, size: 15)
        label.textAlignment = .center
        
        return label
    }()
    
    func configTitle(_ title: String) {
        self.tapButtonTitle.text = title
    }
    
    private func setupConstraints() {
        addSubview(tapButtonTitle)

        tapButtonTitle.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
