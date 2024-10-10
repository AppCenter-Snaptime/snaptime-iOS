//
//  CommentCollectionViewCell.swift
//  Snaptime
//
//  Created by 이대현 on 4/2/24.
//

import UIKit
import SnapKit

final class CommentCollectionViewCell: UICollectionViewCell {
    let commentView = SingleCommentView()
    var action: (()->())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        commentView.setupUI(comment:
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
        
        commentView.profileImageView.image = UIImage()
    }
    
    func setupUI(comment: ChildReplyInfo) {
        self.commentView.setupUI(comment: comment)
        self.commentView.action = action
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
