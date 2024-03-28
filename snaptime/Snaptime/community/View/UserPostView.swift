//
//  UserPostView.swift
//  Snaptime
//
//  Created by 이대현 on 3/25/24.
//

import UIKit

final class UserPostView: UIView {
    private lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person")
        imageView.backgroundColor = .snaptimeGray
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Jocelyn"
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var tagLabel: UILabel = {
        let label = UILabel()
        label.text = "with @Lorem"
        label.font = .systemFont(ofSize: 12)
        label.textColor = .snaptimeGray
        return label
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "SnapExample")
        return imageView
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private lazy var commentButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "message"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private lazy var postLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0 // NOTE: 글이 너무 길어지면 곤란하니까 최대 몇줄까지 보여줄 지 정하는 게 좋을듯
        label.text = "Lorem ipsum dolor sit amet consectetur. Vitae sed malesu ada ornare enim eu sed tortor dui.Lorem ipsum dolor sit amet consectetur. Vitae sed malesu ada ornare enim eu sed tortor dui."
        return label
    }()
    
    private lazy var postDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .snaptimeGray
        label.text = "24.01.15"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayouts()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userImageView.layer.cornerRadius = userImageView.frame.height/2
    }
    
    private func setLayouts() {
        [
            userImageView,
            userNameLabel,
            tagLabel,
            editButton,
            photoImageView,
            likeButton,
            commentButton,
            shareButton,
            postLabel,
            postDateLabel
        ].forEach {
            addSubview($0)
        }
    }
    
    private func setConstraints() {
        userImageView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(20)
            $0.width.height.equalTo(32)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.left.equalTo(userImageView.snp.right).offset(10)
            $0.top.equalTo(userImageView)
        }
        
        tagLabel.snp.makeConstraints {
            $0.left.equalTo(userNameLabel)
            $0.top.equalTo(userNameLabel.snp.bottom).offset(5)
        }
        
        editButton.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-20)
            $0.centerY.equalTo(userImageView)
            $0.width.height.equalTo(32)
        }
        
        photoImageView.snp.makeConstraints {
            $0.top.equalTo(editButton.snp.bottom).offset(20)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(photoImageView.snp.width).multipliedBy(1.33) // 4:3 비율로 설정
        }
        
        likeButton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(photoImageView.snp.bottom).offset(8)
            $0.width.height.equalTo(24)
        }
        
        commentButton.snp.makeConstraints {
            $0.left.equalTo(likeButton.snp.right).offset(7)
            $0.top.equalTo(likeButton)
            $0.width.height.equalTo(24)
        }
        
        shareButton.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalTo(likeButton)
            $0.width.height.equalTo(24)
        }
        
        postLabel.snp.makeConstraints {
            $0.top.equalTo(likeButton.snp.bottom).offset(8)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
        }
        
        postDateLabel.snp.makeConstraints {
            $0.top.equalTo(postLabel.snp.bottom).offset(4)
            $0.left.equalTo(postLabel)
        }
    }
}
