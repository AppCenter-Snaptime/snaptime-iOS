//
//  CommentSupplementaryHeaderView.swift
//  Snaptime
//
//  Created by 이대현 on 4/3/24.
//

import SnapKit
import UIKit

final class CommentSupplementaryHeaderView: UICollectionReusableView {
    let contentView = SingleCommentView()
    var action: (()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        setConstraints()
        contentView.action = action
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(comment: ParentReplyInfo) {
        contentView.setupUI(comment: comment)
    }
    
    private func setLayout() {
        self.addSubview(contentView)
    }
    
    private func setConstraints() {
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
