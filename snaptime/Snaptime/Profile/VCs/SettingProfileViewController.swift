//
//  SettingProfileViewController.swift
//  snaptime
//
//  Created by Bowon Han on 2/1/24.
//

import UIKit
import SnapKit

protocol SettingProfileNavigation : AnyObject {
    func presentSettingProfile()
}

final class SettingProfileViewController : BaseViewController {
    weak var coordinator : SettingProfileNavigation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    init(coordinator: SettingProfileNavigation) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        settingProfileImage.layer.cornerRadius = settingProfileImage.frame.height/2
    }
    
    private lazy var iconLabel : UILabel = {
        let label = UILabel()
        label.text = "Profile"
        label.textColor = .snaptimeBlue
        label.font = .systemFont(ofSize: 24, weight: .regular)
        label.textAlignment = .left
        
        return label
    }()
    
    private lazy var settingProfileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .snaptimeGray
        imageView.clipsToBounds = true

        return imageView
    }()
    
    private lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "blwxnhan"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        
        return label
    }()
    
    private let settingProfileView1 = ProfileSettingView()

    override func setupLayouts() {
        super.setupLayouts()
        
        [iconLabel,
         settingProfileImage,
         nicknameLabel,
         settingProfileView1].forEach {
            view.addSubview($0)
        }
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        iconLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(30)
        }
        
        settingProfileImage.snp.makeConstraints {
            $0.top.equalTo(iconLabel.snp.bottom).offset(40)
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
            $0.height.width.equalTo(120)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(settingProfileImage.snp.bottom).offset(20)
            $0.centerX.equalTo(settingProfileImage.snp.centerX)
        }
        
        settingProfileView1.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(50)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(30)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-30)
        }
    }
}
