//
//  EditProfileViewController.swift
//  snaptime
//
//  Created by Bowon Han on 2/1/24.
//

import UIKit
import SnapKit

protocol EditProfileNavigation: AnyObject {
    func presentEditProfile()
}

final class EditProfileViewController: BaseViewController {
    weak var delegate: EditProfileNavigation?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        editProfileImage.layer.cornerRadius = editProfileImage.frame.height/2
        editProfileImageButton.layer.cornerRadius = editProfileImageButton.frame.height/2
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "프로필 편집"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        
        return label
    }()
        
    private lazy var editProfileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .snaptimeBlue
        imageView.clipsToBounds = true

        return imageView
    }()
    
    private lazy var editProfileImageButton: UIButton = {
        let button = UIButton()
        var descriptionConfig = UIButton.Configuration.filled()
        descriptionConfig.baseBackgroundColor = UIColor.lightGray.withAlphaComponent(0.8)
        descriptionConfig.baseForegroundColor = .white
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .medium)
        let setImage = UIImage(systemName: "camera", withConfiguration: imageConfig)
        
        descriptionConfig.image = setImage
        
        button.configuration = descriptionConfig
        button.clipsToBounds = true
        
        return button
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 25
        
        return stackView
    }()
    
    private let editIDTextField = EditProfileTextField("아이디")
    private let editEmailTextField = EditProfileTextField("이메일")
    private let editPasswordTextField = EditProfileTextField("비밀번호")
    private let editDateOfBirthTextField = EditProfileTextField("생년월일")
    private let editNameTextField = EditProfileTextField("이름")
    
    override func setupLayouts() {
        super.setupLayouts()
         
        [editIDTextField,
         editEmailTextField,
         editPasswordTextField,
         editDateOfBirthTextField,
         editNameTextField].forEach {
            stackView.addArrangedSubview($0)
        }
        
        [titleLabel,
         editProfileImage,
         editProfileImageButton,
         stackView].forEach {
            view.addSubview($0)
        }
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            $0.centerX.equalToSuperview()
        }
        
        editProfileImage.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(22)
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
            $0.height.width.equalTo(120)
        }
        
        editProfileImageButton.snp.makeConstraints {
            $0.top.equalTo(editProfileImage.snp.top)
            $0.bottom.equalTo(editProfileImage.snp.bottom)
            $0.left.equalTo(editProfileImage.snp.left)
            $0.right.equalTo(editProfileImage.snp.right)
        }
         
        stackView.snp.makeConstraints {
            $0.top.equalTo(editProfileImage.snp.bottom).offset(40)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(53)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-53)
        }
    }
}
