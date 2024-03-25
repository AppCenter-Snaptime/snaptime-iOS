//
//  CommunityCollectionViewCell.swift
//  Snaptime
//
//  Created by 이대현 on 3/25/24.
//

import UIKit

final class CommunityCollectionViewCell: UICollectionViewCell {
    private let userPostView = UserPostView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayouts()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayouts() {
        self.contentView.addSubview(userPostView)
    }
    
    private func setConstraints() {
        userPostView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
