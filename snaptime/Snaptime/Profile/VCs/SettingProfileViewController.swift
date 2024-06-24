//
//  SettingProfileViewController.swift
//  snaptime
//
//  Created by Bowon Han on 2/1/24.
//

import UIKit
import SnapKit
import Kingfisher

protocol SettingProfileDelegate: AnyObject {
    func presentSettingProfile()
    func presentEditProfile()
}

final class SettingProfileViewController: BaseViewController {
    weak var delegate: SettingProfileDelegate?
    private var userProfile = UserProfileManager.shared.profile.result
    
    private let loginId = "bowon0000"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.idLabel.text = userProfile.userName
        self.loadImage(data: userProfile.profileURL)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        profileImage.layer.cornerRadius = profileImage.frame.height/2
    }
    
    private lazy var iconLabel: UILabel = {
        let label = UILabel()
        label.text = "Profile"
        label.textColor = .snaptimeBlue
        label.font = .systemFont(ofSize: 24, weight: .regular)
        label.textAlignment = .left
        
        return label
    }()
    
    private lazy var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .snaptimeGray
        imageView.clipsToBounds = true

        return imageView
    }()
    
    private lazy var idLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        
        return label
    }()
    
    private lazy var settingProfileView1 = ProfileSettingView(first: "프로필 편집",
                                                         second: "알림",
                                                         firstAction: UIAction {  _ in
        self.delegate?.presentEditProfile()
    },
                                                         secondAction: UIAction { _ in
    })
    private let settingProfileView2 = ProfileSettingView(first: "Help&Support", 
                                                         second: "FAQ",
                                                         firstAction: UIAction {  _ in
    },
                                                         secondAction: UIAction { _ in
    })
    private let settingProfileView3 = ProfileSettingView(first: "보안 정책", 
                                                         second: "수정",
                                                         firstAction: UIAction { _ in
    },
                                                         secondAction: UIAction { _ in
    })
    
    private func loadImage(data: String) {
        guard let url = URL(string: data)  else { return }
        
        let backgroundQueue = DispatchQueue(label: "background_queue",qos: .background)
        
        backgroundQueue.async {
            guard let data = try? Data(contentsOf: url) else { return }
            
            DispatchQueue.main.async {
                self.profileImage.image = UIImage(data: data)
            }
        }
    }

    // MARK: - Set Layouts
    override func setupLayouts() {
        super.setupLayouts()
        
        [iconLabel,
         profileImage,
         idLabel,
         settingProfileView1,
         settingProfileView2,
         settingProfileView3].forEach {
            view.addSubview($0)
        }
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        iconLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(30)
        }
        
        profileImage.snp.makeConstraints {
            $0.top.equalTo(iconLabel.snp.bottom).offset(40)
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
            $0.height.width.equalTo(120)
        }
        
        idLabel.snp.makeConstraints {
            $0.top.equalTo(profileImage.snp.bottom).offset(20)
            $0.centerX.equalTo(profileImage.snp.centerX)
        }
        
        settingProfileView1.snp.makeConstraints {
            $0.top.equalTo(idLabel.snp.bottom).offset(50)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(30)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-30)
        }
        
        settingProfileView2.snp.makeConstraints {
            $0.top.equalTo(settingProfileView1.snp.bottom).offset(30)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(30)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-30)
        }
        
        settingProfileView3.snp.makeConstraints {
            $0.top.equalTo(settingProfileView2.snp.bottom).offset(30)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(30)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-30)
        }
    }
}
