//
//  NotificationCollectionViewCell.swift
//  Snaptime
//
//  Created by Bowon Han on 3/21/24.
//

import UIKit
import SnapKit

enum NotificationType: CaseIterable {
    case follow, reply, like, snapTag
    
    init(title: String) {
        switch title {
        case "FOLLOW": self = .follow
        case "REPLY": self = .reply
        case "SNAPTAG": self = .snapTag
        case "LIKE": self = .like
        default: self = .follow
        }
    }
    
    func toKoComment() -> String {
        switch self {
        case .follow:
            return "팔로우"
        case .reply:
            return "댓글"
        case .like:
            return "좋아요"
        case .snapTag:
            return "태그"
        }
    }
}

final class NotificationCollectionViewCell: UICollectionViewCell {
    private var notificationType: NotificationType = .follow
    var previewImageClickAction: (()->())?
    var profileImageClickAction: (()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        previewImage.image = UIImage()
        profileImageView.image = UIImage()
        commentTitle.text = ""
        commentContent.text = ""
        timeInformation.text = ""
        previewImage.isHidden = false
    }
    
    private lazy var previewImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .snaptimeGray
        imageView.contentMode = .scaleAspectFit
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(partnerProfileTap))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true

        return imageView
    }()
    
    private lazy var profileImageView: RoundImageView = {
        let imageView = RoundImageView()
        imageView.backgroundColor = .snaptimeGray

        return imageView
    }()
    
    private lazy var commentTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: SuitFont.medium, size: 13)
        label.numberOfLines = 2
        
        return label
    }()
    
    private lazy var timeInformation: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: SuitFont.medium, size: 12)
        label.textColor = UIColor.init(hexCode: "747474")
        label.textAlignment = .right
        
        return label
    }()
    
    private lazy var commentContent: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: SuitFont.regular, size: 12)
        label.numberOfLines = 2
        label.textColor = .gray
        
        return label
    }()
    
    @objc func partnerProfileTap(_ gesture: UITapGestureRecognizer) {
        guard let action = self.previewImageClickAction else { return }
        action()
    }
    
    func configureData(data: AlarmInfoResDto, type: NotificationType) {
        APIService.loadImageNonToken(data: data.senderProfilePhotoURL, imageView: profileImageView)
        
        if let snapPhotoURL = data.snapPhotoURL {
            APIService.loadImage(data: snapPhotoURL, imageView: previewImage)
        }
        
        var comment: String = ""

        switch type {
        case .follow:
            comment = "\(data.senderName)님이 회원님을 팔로우합니다."
            previewImage.isHidden = true
        case .like:
            comment = "\(data.senderName)님이 좋아합니다."
        case .reply:
            comment = "\(data.senderName)님이 댓글을 남겼습니다."
        case .snapTag:
            comment = "\(data.senderName)님이 회원님을 태그하였습니다."
        }
        
        commentTitle.text = comment
        commentContent.text = data.previewText
        timeInformation.text = data.timeAgo
    }
    
    
    private func setupLayout() {
        [profileImageView,
         commentTitle,
         timeInformation,
         commentContent,
         previewImage].forEach {
            addSubview($0)
        }
        
        profileImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(20)
            $0.left.equalToSuperview().offset(20)
            $0.width.equalTo(profileImageView.snp.height)
        }
        
        timeInformation.snp.makeConstraints {
            $0.top.equalTo(commentTitle.snp.top)
            $0.right.equalTo(previewImage.snp.left).offset(-8)
            $0.width.greaterThanOrEqualTo(20)
            $0.height.equalTo(14)
        }
        
        commentTitle.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.top)
            $0.left.equalTo(profileImageView.snp.right).offset(16)
            $0.right.equalTo(timeInformation.snp.left).offset(-5)
            $0.height.equalTo(15)
        }
        
        commentContent.snp.makeConstraints {
            $0.top.equalTo(commentTitle.snp.bottom)
            $0.left.equalTo(commentTitle.snp.left)
            $0.bottom.equalToSuperview().offset(-14)
            $0.right.equalTo(commentTitle.snp.right)
        }

        previewImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(14)
            $0.bottom.equalToSuperview().offset(-14)
            $0.right.equalToSuperview().offset(-20)
            $0.width.equalTo(49)
        }
    }
}
