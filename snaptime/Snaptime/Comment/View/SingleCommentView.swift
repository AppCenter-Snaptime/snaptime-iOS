//
//  SingleCommentView.swift
//  Snaptime
//
//  Created by 이대현 on 4/2/24.
//

import UIKit

class SingleCommentView: UIView {
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person")
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
        label.text = "Jocelyn"
        return label
    }()
    
    private lazy var beforeDateLabel: UILabel = {
        let label = UILabel()
        label.text = "30분 전"
        return label
    }()
    
    private lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Lorem ipsum dolor sit amet consectetur. Vitae sed malesu ada ornare enim eu sed tortor dui.Lorem ipsum dolor sit amet consectetur. Vitae sed malesu ada ornare enim eu sed tortor dui."
        return label
    }()
    
    private lazy var replyLabel: UILabel = {
        let label = UILabel()
        label.text = "답글 달기"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setLayout()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        
        [
            profileImageView,
            upperStackView,
            commentLabel,
            replyLabel
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
            $0.top.equalTo(profileImageView).offset(-3)
        }
//        
//        nameLabel.snp.makeConstraints {
//            $0.left.equalTo(profileImageView.snp.right).offset(15)
//            $0.top.equalTo(profileImageView).offset(-3)
//        }
//        
//        beforeDateLabel.snp.makeConstraints {
//            $0.top.equalTo(nameLabel)
//            $0.left.equalTo(nameLabel.snp.right).offset(<#T##amount: any ConstraintOffsetTarget##any ConstraintOffsetTarget#>)
//        }
        
        commentLabel.snp.makeConstraints {
            $0.left.equalTo(upperStackView)
            $0.top.equalTo(upperStackView.snp.bottom).offset(2)
            $0.right.equalToSuperview().offset(-20)
        }
        
        replyLabel.snp.makeConstraints {
            $0.top.equalTo(commentLabel.snp.bottom).offset(4)
            $0.left.equalTo(commentLabel)
        }
    }
}
