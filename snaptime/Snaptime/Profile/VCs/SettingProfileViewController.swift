//
//  SettingProfileViewController.swift
//  snaptime
//
//  Created by Bowon Han on 2/1/24.
//

import UIKit
import SnapKit
import Kingfisher

protocol SettingProfileViewControllerDelegate: AnyObject {
    func presentSettingProfile()
    func presentEditProfile()
    func backToPrevious()
}

final class SettingProfileViewController: BaseViewController {
    weak var delegate: SettingProfileViewControllerDelegate?
    private var userProfile = UserProfileManager.shared.profile.result
    
    private let loginId = ProfileBasicModel.profile.loginId
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.idLabel.text = userProfile.userName
        self.loadImage(data: userProfile.profileURL)
        self.setNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        profileImage.layer.cornerRadius = profileImage.frame.height/2
    }
    
    private lazy var iconButton: UIButton = {
        let button = UIButton()

        var buttonConfig = UIButton.Configuration.filled()
        buttonConfig.baseBackgroundColor = .white
        buttonConfig.baseForegroundColor = .snaptimeBlue
        
        var titleAttr = AttributedString.init("Profile")
        titleAttr.font = .systemFont(ofSize: 25, weight: .medium)
        let imageConfig = UIImage.SymbolConfiguration(hierarchicalColor: .black)

        let setImage = UIImage(systemName: "chevron.backward", withConfiguration: imageConfig)
        
        buttonConfig.attributedTitle = titleAttr
        buttonConfig.image = setImage
        buttonConfig.imagePlacement = .leading
        buttonConfig.imagePadding = 5
        
        button.configuration = buttonConfig
        button.addAction(UIAction{ [weak self] _ in
            self?.delegate?.backToPrevious()
        }, for: .touchUpInside)
                
        return button
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
                                                         firstAction: UIAction { [weak self] _ in
        self?.delegate?.presentEditProfile()
    },
                                                         secondAction: UIAction { [weak self] _ in
    })
    private lazy var settingProfileView2 = ProfileSettingView(first: "Help&Support",
                                                         second: "FAQ",
                                                         firstAction: UIAction { [weak self] _ in
    },
                                                         secondAction: UIAction { [weak self] _ in
    })
    private lazy var settingProfileView3 = ProfileSettingView(first: "보안 정책",
                                                         second: "수정",
                                                         firstAction: UIAction { [weak self] _ in
    },
                                                         secondAction: UIAction { [weak self] _ in
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
    
    private func setNavigationBar() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: iconButton)
    }

    // MARK: - Set Layouts
    override func setupLayouts() {
        super.setupLayouts()
        
        [profileImage,
         idLabel,
         settingProfileView1,
         settingProfileView2,
         settingProfileView3].forEach {
            view.addSubview($0)
        }
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        profileImage.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(40)
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
