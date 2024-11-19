//
//  SingleCommentView.swift
//  Snaptime
//
//  Created by 이대현 on 4/2/24.
//

import Kingfisher
import UIKit

class SingleCommentView: UIView {
    var action: (()->())?
    var addReplyButtonAction: (()->())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setLayout()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var profileImageView: RoundImageView = {
        let imageView = RoundImageView()
        imageView.backgroundColor = .snaptimeGray
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(partnerProfileTap))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var upperStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: SuitFont.semiBold, size: 15)
        return label
    }()
    
    private lazy var beforeDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: SuitFont.regular, size: 11)
        label.textColor = UIColor(hexCode: "747474")
        return label
    }()
    
    private lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: SuitFont.medium, size: 14)
        return label
    }()
    
    private lazy var replyButton: UIButton = {
        let button = UIButton()
        button.setTitle("답글 달기", for: .normal)
        button.titleLabel?.font = UIFont(name: SuitFont.medium, size: 12)
        button.setTitleColor(UIColor(hexCode: "747474"), for: .normal)
        button.addAction(UIAction{ [weak self] _ in
            guard let action = self?.addReplyButtonAction else { return }
            action()
        }, for: .touchUpInside)
        return button
    }()
    
    func setupUI(comment: ParentReplyInfo) {
        nameLabel.text = comment.writerUserName
        commentLabel.text = comment.content
        beforeDateLabel.text = comment.timeAgo
        
        APIService.loadImageNonToken(data: comment.writerProfilePhotoURL, imageView: self.profileImageView)
    }
    
    func setupUI(comment: ChildReplyInfo) {
        nameLabel.text = comment.writerUserName
        commentLabel.text = comment.content
        beforeDateLabel.text = comment.timeAgo
        
        APIService.loadImageNonToken(data: comment.writerProfilePhotoURL, imageView: self.profileImageView)
    }
    
    @objc func partnerProfileTap(_ gesture: UITapGestureRecognizer) {
        guard let action = self.action else { return }
        action()
    }
    
    private func setLayout() {
        
        [
            profileImageView,
            upperStackView,
            commentLabel,
            replyButton
        ].forEach {
            self.addSubview($0)
        }
        
        [
            nameLabel,
            beforeDateLabel
        ].forEach {
            self.upperStackView.addArrangedSubview($0)
        }
    }
    
    private func setConstraints() {
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.left.equalToSuperview().offset(20)
            $0.width.height.equalTo(32)
        }
        
        upperStackView.snp.makeConstraints {
            $0.left.equalTo(profileImageView.snp.right).offset(15)
            $0.top.equalToSuperview().offset(18)
        }
        
        commentLabel.snp.makeConstraints {
            $0.left.equalTo(upperStackView.snp.left)
            $0.top.equalTo(upperStackView.snp.bottom).offset(2)
            $0.right.equalToSuperview().offset(-20)
        }
        
        replyButton.snp.makeConstraints {
            $0.top.equalTo(commentLabel.snp.bottom).offset(4)
            $0.left.equalTo(commentLabel)
            $0.bottom.equalToSuperview().offset(-1)
        }
    }
}
