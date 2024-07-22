//
//  EditProfileViewController.swift
//  snaptime
//
//  Created by Bowon Han on 2/1/24.
//

import UIKit
import SnapKit
import Kingfisher

protocol EditProfileViewControllerDelegate: AnyObject {
    func presentEditProfile()
    func backToRoot()
}

final class EditProfileViewController: BaseViewController {
    weak var delegate: EditProfileViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchUserInfo()
        APIService.loadImageNonToken(data: UserProfileManager.shared.profile.result.profileURL, imageView: editProfileImage)
        self.setNavigationBar()
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
        descriptionConfig.baseBackgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
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
    
    private lazy var fixButton: UIButton = {
        let button = UIButton()
        var buttonConfig = UIButton.Configuration.filled()
        buttonConfig.baseBackgroundColor = .white
        buttonConfig.baseForegroundColor = .snaptimeBlue
        
        var titleAttr = AttributedString.init("완료")
        titleAttr.font = .systemFont(ofSize: 16.0, weight: .semibold)
        
        buttonConfig.attributedTitle = titleAttr
        
        button.configuration = buttonConfig
        button.addAction(UIAction{ [weak self] _ in
            if let id = self?.editIDTextField.editTextField.text,
               let email = self?.editEmailTextField.editTextField.text,
               let birthDate = self?.editDateOfBirthTextField.editTextField.text,
               let name = self?.editNameTextField.editTextField.text {
                let param = UserUpdateDto(name: name, loginId: id, email: email, birthDay: birthDate)
                
                print(param)
                self?.modifyUserInfo(userInfo: param)
                
                self?.delegate?.backToRoot()
            }
        }, for: .touchUpInside)
        
        return button
    }()
    
    private let editIDTextField = EditProfileTextField("아이디")
    private let editEmailTextField = EditProfileTextField("이메일")
    private let editDateOfBirthTextField = EditProfileTextField("생년월일")
    private let editNameTextField = EditProfileTextField("이름")
    
    // MARK: - 사용자 정보 서버에서 불러오기
    private func fetchUserInfo() {
        APIService.fetchUserInfo.performRequest { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let userProfileInfo):
                    if let profile = userProfileInfo as? CommonResponseDtoUserResDto {
                        self.editIDTextField.editTextField.text = profile.result.loginId
                        self.editEmailTextField.editTextField.text = profile.result.email
                        self.editDateOfBirthTextField.editTextField.text = profile.result.birthDay
                        self.editNameTextField.editTextField.text = profile.result.name
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func modifyUserInfo(userInfo: UserUpdateDto) {
        APIService.modifyUserInfo.performRequest(with: userInfo) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    print("modify user information")
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    // MARK: - navigationBar 설정
    private func setNavigationBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: fixButton)
        self.navigationItem.title = "프로필 편집"
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .regular)]
    }
    
    // MARK: - Set Layout
    override func setupLayouts() {
        super.setupLayouts()
         
        [editIDTextField,
         editEmailTextField,
         editDateOfBirthTextField,
         editNameTextField].forEach {
            stackView.addArrangedSubview($0)
        }
        
        [editProfileImage,
         editProfileImageButton,
         stackView].forEach {
            view.addSubview($0)
        }
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        editProfileImage.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(22)
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
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(35)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-35)
        }
    }
}
