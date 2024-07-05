//
//  SnapCollectionViewCell.swift
//  snaptime
//
//  Created by Bowon Han on 2/14/24.
//

import UIKit
import SnapKit
import Kingfisher

protocol SnapCollectionViewCellDelegate: AnyObject {
    func didTapCommentButton()
}

final class SnapCollectionViewCell: UICollectionViewCell {
    /// 버튼 event 전달 delegate
    weak var delegate: SnapCollectionViewCellDelegate?
    var action: (()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setLayouts()
        self.setConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        userImageView.layer.cornerRadius = userImageView.frame.height/2
    }
        
    private lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .snaptimeGray
        imageView.clipsToBounds = true
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: action))
//        imageView.addGestureRecognizer(tapGesture)
//        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Jocelyn"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        
        return label
    }()
    
    private lazy var tagLabel: UILabel = {
        let label = UILabel()
        label.text = "with @Lorem"
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor.init(hexCode: "#909090")
        
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
        imageView.backgroundColor = .snaptimeGray

        return imageView
    }()
    
    private lazy var commentButton = IconButton(
        name: "message",
        action: UIAction { [weak self] _ in
            self?.delegate?.didTapCommentButton()
    })
    
    private lazy var likeButton = IconButton(
        name: "heart",
        action: UIAction { [weak self] _ in })

    private lazy var shareButton = IconButton(
        name: "square.and.arrow.up",
        action: UIAction { [weak self] _ in })
    
    private lazy var postLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0 // NOTE: 글이 너무 길어지면 곤란하니까 최대 몇줄까지 보여줄 지 정하는 게 좋을듯
        
        return label
    }()
    
    private lazy var commentCheckButton: UIButton = {
        let button = UIButton()
        button.setTitle("댓글보기", for: .normal)
        button.setTitleColor(UIColor.init(hexCode: "#B2B2B2"), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
        button.addAction(UIAction { [weak self] _ in
            self?.delegate?.didTapCommentButton()
        }, for: .touchUpInside)
        
        return button
    }()
    
    private lazy var postDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .black
        label.text = "24.01.15"
        
        return label
    }()
    
    @objc func partnerProfileTap(_ gesture: UITapGestureRecognizer) {
        print("partnerProfileTap")
    }

    func configureData(data: SnapResDTO) {
        self.loadImage(data: UserProfileManager.shared.profile.result.profileURL, imageView: userImageView)
        userNameLabel.text = UserProfileManager.shared.profile.result.userName
        self.loadImage(data: data.snapPhotoURL, imageView: photoImageView)
        postLabel.text = data.oneLineJournal
        postDateLabel.text = "2024.01.09"
    }
    
    private func loadImage(data: String, imageView: UIImageView) {
        if let url = URL(string: data) {
            let modifier = AnyModifier { request in
                var r = request
                r.setValue("*/*", forHTTPHeaderField: "accept")
                r.setValue(ACCESS_TOKEN, forHTTPHeaderField: "Authorization")
                return r
            }
            
            imageView.kf.setImage(with: url, options: [.requestModifier(modifier)]) { result in
                switch result {
                case .success(_):
                    print("success fetch image")
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func setLayouts() {
        self.layer.shadowColor = UIColor(hexCode: "c4c4c4").cgColor
        self.layer.shadowPath = UIBezierPath(rect: CGRect(x: self.bounds.origin.x - 0.5, y: self.bounds.origin.y , width: self.bounds.width + 0.5, height: self.bounds.height + 0.5)).cgPath
        self.layer.shadowOpacity = 20
        self.layer.shadowRadius = 6
        self.contentView.layer.cornerRadius = 15
        self.contentView.layer.masksToBounds = true
        self.contentView.backgroundColor = UIColor.init(hexCode: "#F8F8F8")
        
        [userImageView,
         userNameLabel,
         tagLabel,
         editButton,
         photoImageView,
         commentButton,
         likeButton,
         shareButton,
         postLabel,
         commentCheckButton,
         postDateLabel].forEach {
            self.contentView.addSubview($0)
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
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(photoImageView.snp.width).multipliedBy(1.33) // 4:3 비율로 설정
        }
        
        commentButton.snp.makeConstraints {
            $0.left.equalTo(photoImageView.snp.left)
            $0.top.equalTo(photoImageView.snp.bottom).offset(8)
            $0.width.height.equalTo(24)
        }
        
        likeButton.snp.makeConstraints {
            $0.left.equalTo(commentButton.snp.right).offset(8)
            $0.top.equalTo(commentButton)
            $0.width.height.equalTo(24)
        }
        
        shareButton.snp.makeConstraints {
            $0.right.equalTo(photoImageView.snp.right)
            $0.top.equalTo(commentButton)
            $0.width.height.equalTo(24)
        }
        
        postLabel.snp.makeConstraints {
            $0.top.equalTo(commentButton.snp.bottom).offset(8)
            $0.left.right.equalTo(photoImageView)
        }
        
        commentCheckButton.snp.makeConstraints {
            $0.top.equalTo(postLabel.snp.bottom).offset(10)
            $0.left.equalTo(photoImageView.snp.left)
            $0.height.equalTo(postDateLabel)
        }
        
        postDateLabel.snp.makeConstraints {
            $0.top.equalTo(postLabel.snp.bottom).offset(10)
            $0.right.equalTo(photoImageView.snp.right)
        }
    }
}
