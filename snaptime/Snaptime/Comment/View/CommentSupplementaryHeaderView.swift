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
    var addReplyButtonAction: (()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        setConstraints()
//        contentView.action = action
//        contentView.addReplyButtonAction = addReplyButtonAction
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        contentView.setupUI(comment:
            ParentReplyInfo(
                writerEmail: "",
                writerProfilePhotoURL: "",
                writerUserName: "",
                content: "",
                replyId: 0,
                timeAgo: "",
                childReplyCnt: 0
            )
        )
        
        contentView.profileImageView.image = UIImage()
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
