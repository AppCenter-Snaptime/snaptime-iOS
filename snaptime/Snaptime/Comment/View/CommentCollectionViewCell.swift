//
//  CommentCollectionViewCell.swift
//  Snaptime
//
//  Created by 이대현 on 4/2/24.
//

import UIKit

final class CommentCollectionViewCell: UICollectionViewCell {
    let commentView = SingleCommentView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        self.contentView.addSubview(commentView)
    }
    
    private func setConstraints() {
        commentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
