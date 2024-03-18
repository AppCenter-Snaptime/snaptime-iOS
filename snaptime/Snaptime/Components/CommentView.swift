//
//  CommentView.swift
//  Snaptime
//
//  Created by Bowon Han on 3/18/24.
//

import UIKit
import SnapKit

final class CommentView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
    }
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .snaptimeGray
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    private lazy var commentTitle: UILabel = {
        let label = UILabel()
        label.text = "Lorem님이 댓글을 남겼습니다."
        label.font = .systemFont(ofSize: 15, weight: .regular)
        
        return label
    }()
    
    private lazy var timeInformation: UILabel = {
        let label = UILabel()
        label.text = "10분 전"
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .snaptimeGray
        
        return label
    }()
    
    private lazy var commentContent: UILabel = {
        let label = UILabel()
        label.text = "@Jocelyn ipsum dolor sit amet consectetur. Vitae sed ..."
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 2
        label.textColor = .gray
        
        return label
    }()
    
    private func setupLayout() {
        [profileImageView, 
         commentTitle,
         timeInformation,
         commentContent].forEach {
            addSubview($0)
        }
        
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview()
            $0.height.width.equalTo(40)
        }
        
        commentTitle.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.top)
            $0.left.equalTo(profileImageView.snp.right).offset(16)
            $0.height.equalTo(18)
        }
        
        timeInformation.snp.makeConstraints {
            $0.bottom.equalTo(commentTitle.snp.bottom)
            $0.left.equalTo(commentTitle.snp.right).offset(8)
            $0.right.equalToSuperview()
            $0.height.equalTo(14)
        }
        
        commentContent.snp.makeConstraints {
            $0.top.equalTo(commentTitle.snp.bottom).offset(3)
            $0.left.equalTo(commentTitle.snp.left)
            $0.bottom.equalToSuperview()
            $0.width.equalTo(203)
        }
    }
}
