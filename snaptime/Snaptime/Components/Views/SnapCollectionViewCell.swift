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
    func didTapCommentButton(snap: FindSnapResDto)
    func didTapEditButton(snap: FindSnapResDto)
}

final class SnapCollectionViewCell: UICollectionViewCell {
    /// 버튼 event 전달 delegate
    weak var delegate: SnapCollectionViewCellDelegate?
    var profileTapAction: (()->())?
    var tagButtonTapAction: (()->())?
    private var snap: FindSnapResDto?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setLayouts()
        self.setConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private lazy var userImageView: RoundImageView = {
        let imageView = RoundImageView()
        imageView.backgroundColor = .snaptimeGray
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleToFill
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(partnerProfileTap))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Jocelyn"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        
        return label
    }()
    
    private lazy var tagButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .regular)
        button.setTitleColor(UIColor.init(hexCode: "#909090"), for: .normal)
        button.addAction(UIAction { [weak self] _ in
            guard let action = self?.tagButtonTapAction else { return }
            action()
        }, for: .touchUpInside)
        
        return button
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = .black
        button.addAction(UIAction { [weak self] _ in
            guard let snap = self?.snap else { return }
            self?.delegate?.didTapEditButton(snap: snap)
        }, for: .touchUpInside)
        return button
    }()
    
    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .snaptimeGray
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()
    
    private lazy var commentButton = IconButton(
        name: "message",
        size: 15,
        action: UIAction { [weak self] _ in
            guard let snap = self?.snap else { return }
            self?.delegate?.didTapCommentButton(snap: snap)
        })
    
    private var isLikeSnap: Bool = false {
        didSet {
            let image = isLikeSnap ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
            likeButton.configuration?.image = image
        }
    }
    
    private lazy var likeButton = IconButton(
        name: "heart",
        size: 15,
        action: UIAction { [weak self] _ in
            guard let self = self,
                  let snap = self.snap else { return }
            self.isLikeSnap.toggle()
            APIService.postLikeToggle(snapId: snap.snapId).performRequest(
                responseType: CommonResDtoVoid.self
            ) { result in
                
                switch result {
                case .success(_):
                    print("좋아요 Toggle Success")
                case .failure(let error):
                    print(error)
                }
            }
        }
    )
    
    private lazy var likeButtonCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .medium)
        
        return label
    }()

    private lazy var shareButton = IconButton(
        name: "square.and.arrow.up",
        size: 15,
        action: UIAction { [weak self] _ in })
    
    private lazy var oneLineJournalLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var plusOneLineJournalButton: UIButton = {
        let button = UIButton()
        button.setTitle("더보기", for: .normal)
        button.setTitleColor(UIColor.init(hexCode: "#B2B2B2"), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
        button.isHidden = true
        
        return button
    }()
    
    private lazy var commentCheckButton: UIButton = {
        let button = UIButton()
        button.setTitle("댓글보기", for: .normal)
        button.setTitleColor(UIColor.init(hexCode: "#B2B2B2"), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
        button.addAction(UIAction { [weak self] _ in
            if let snap = self?.snap {
                self?.delegate?.didTapCommentButton(snap: snap)
            }
        }, for: .touchUpInside)
        
        return button
    }()
    
    private lazy var postDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .black
        
        return label
    }()
    
    @objc func partnerProfileTap(_ gesture: UITapGestureRecognizer) {
        guard let action = self.profileTapAction else { return }
        action()
    }

    func configureData(data: FindSnapResDto, editButtonToggle: Bool = true) {
        self.snap = data
        self.loadImage(data: data.profilePhotoURL, imageView: userImageView)
        userNameLabel.text = data.writerUserName
        APIService.loadImage(data: data.snapPhotoURL, imageView: photoImageView)
        oneLineJournalLabel.text = data.oneLineJournal
        postDateLabel.text = data.snapCreatedDate.toDateString()
        tagButton.setTitle(data.tagUserFindResDtos.count == 0 ? ""
                           : data.tagUserFindResDtos.count == 1 ? "with @\(data.tagUserFindResDtos[0].tagUserName)"
                           : "with @\(data.tagUserFindResDtos[0].tagUserName) + \(data.tagUserFindResDtos.count - 1) others", for: .normal)
        isLikeSnap = data.isLikedSnap
        likeButtonCountLabel.text = String(data.likeCnt)
        
        if !editButtonToggle {
            editButton.isHidden = true
        }
        
        else {
            editButton.isHidden = false
        }
    }
    
    private func loadImage(data: String, imageView: UIImageView) {
        guard let url = URL(string: data)  else { return }
        
        let backgroundQueue = DispatchQueue(label: "background_queue",qos: .background)
        
        backgroundQueue.async {
            guard let data = try? Data(contentsOf: url) else { return }
            
            DispatchQueue.main.async {
                imageView.image = UIImage(data: data)
            }
        }
    }
    
    private func setLayouts() {
        self.layer.shadowColor = UIColor(hexCode: "c4c4c4").cgColor
        self.layer.shadowOpacity = 10
        self.layer.shadowRadius = 6
        self.contentView.layer.cornerRadius = 15
        self.contentView.layer.masksToBounds = true
        self.contentView.backgroundColor = UIColor.init(hexCode: "#F8F8F8")
        
        [userImageView,
         userNameLabel,
         tagButton,
         editButton,
         photoImageView,
         commentButton,
         likeButton,
         likeButtonCountLabel,
         shareButton,
         oneLineJournalLabel,
         plusOneLineJournalButton,
         commentCheckButton,
         postDateLabel].forEach {
            self.contentView.addSubview($0)
        }
    }
    
    private func setConstraints() {
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        userImageView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(20)
            $0.width.height.equalTo(32)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.left.equalTo(userImageView.snp.right).offset(10)
            $0.top.equalTo(userImageView)
        }
        
        tagButton.snp.makeConstraints {
            $0.left.equalTo(userNameLabel)
            $0.top.equalTo(userNameLabel.snp.bottom).offset(2)
            $0.height.equalTo(15)
        }
        
        editButton.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-20)
            $0.centerY.equalTo(userImageView)
            $0.width.height.equalTo(32)
        }
        
        photoImageView.snp.makeConstraints {
            let width = UIScreen.main.bounds.width
            
            $0.top.equalTo(editButton.snp.bottom).offset(20)
            $0.width.equalTo(width-80)
            $0.centerX.equalToSuperview()
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
        
        likeButtonCountLabel.snp.makeConstraints {
            $0.left.equalTo(likeButton.snp.right).offset(5)
            $0.top.equalTo(likeButton)
            $0.height.equalTo(likeButton)
        }
        
        shareButton.snp.makeConstraints {
            $0.right.equalTo(photoImageView.snp.right)
            $0.top.equalTo(commentButton)
            $0.width.height.equalTo(24)
        }
        
        oneLineJournalLabel.snp.makeConstraints {
            $0.top.equalTo(commentButton.snp.bottom).offset(8)
            $0.left.right.equalTo(photoImageView)
        }
        
        plusOneLineJournalButton.snp.makeConstraints {
            $0.top.equalTo(oneLineJournalLabel.snp.bottom)
            $0.left.equalTo(oneLineJournalLabel.snp.left)
        }
        
        commentCheckButton.snp.makeConstraints {
            $0.top.equalTo(plusOneLineJournalButton.snp.bottom).offset(15)
            $0.left.equalTo(photoImageView.snp.left)
            $0.height.equalTo(postDateLabel)
        }
        
        postDateLabel.snp.makeConstraints {
            $0.top.equalTo(commentCheckButton.snp.top)
            $0.right.equalTo(photoImageView.snp.right)
            $0.bottom.equalToSuperview().offset(-10)
        }
    }
}
