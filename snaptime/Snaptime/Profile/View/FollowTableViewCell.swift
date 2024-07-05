//
//  FollowTableViewCell.swift
//  Snaptime
//
//  Created by Bowon Han on 7/5/24.
//

import UIKit
import SnapKit

final class FollowTableViewCell: UITableViewCell {
    var follow: Bool = true {
        didSet {
            updateFollowButtonTitle()
        }
    }
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupLayouts()
        self.setupConstraints()
        self.updateFollowButtonTitle()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    private lazy var profileImageView: RoundImageView = {
        let imageView = RoundImageView()
        imageView.backgroundColor = .snaptimeGray
        
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textColor = .black
        label.text = "한보원"
        
        return label
    }()
    
    private lazy var followButton: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.filled()
        config.background.cornerRadius = 50
        button.configuration = config
        button.addAction(UIAction { [weak self] _ in
            self?.followButtonclick()
        }, for: .touchUpInside)

        return button
    }()
    
    private func updateFollowButtonTitle() {
        var config = followButton.configuration

        switch follow {
        case true:
            config?.baseForegroundColor = .black
            config?.background.backgroundColor = .white
            config?.background.strokeColor = .followButtonGray
        case false:
            config?.baseBackgroundColor = .followButtonGray
            config?.background.backgroundColor = .followButtonGray
            config?.baseForegroundColor = .white
        }
        
        var titleAttr = AttributedString(follow ? "팔로잉" : "팔로우하기")
        titleAttr.font = .systemFont(ofSize: 15, weight: .bold)
        
        config?.attributedTitle = titleAttr
        followButton.configuration = config
    }
    
    private func followButtonclick() {
        follow.toggle()
    }
    
    func configData(follow: Bool, data: FindFriendResDto) {
        self.follow = follow
        
        loadImage(data: data.profilePhotoURL)
        nameLabel.text = data.userName
    }
    
    private func loadImage(data: String) {
        guard let url = URL(string: data)  else { return }
        
        let backgroundQueue = DispatchQueue(label: "background_queue",qos: .background)
        
        backgroundQueue.async {
            guard let data = try? Data(contentsOf: url) else { return }
            
            DispatchQueue.main.async {
                self.profileImageView.image = UIImage(data: data)
            }
        }
    }
    
    // MARK: - UI Layouts config
    private func setupLayouts() {
        [profileImageView, 
         nameLabel,
         followButton].forEach {
            contentView.addSubview($0)
        }
    }
    
    // MARK: - UI Constraints config
    private func setupConstraints() {
        profileImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.left.equalToSuperview().offset(20)
            $0.width.height.equalTo(56)
        }
        
        nameLabel.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView.snp.centerY)
            $0.left.equalTo(profileImageView.snp.right).offset(20)
            $0.right.equalTo(followButton.snp.left).offset(-20)
        }
        
        followButton.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView.snp.centerY)
            $0.right.equalToSuperview().offset(-20)
            $0.width.equalTo(104)
            $0.height.equalTo(35)
        }
    }
}
