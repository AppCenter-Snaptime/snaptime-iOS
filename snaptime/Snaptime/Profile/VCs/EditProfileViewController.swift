//
//  EditProfileViewController.swift
//  snaptime
//
//  Created by Bowon Han on 2/1/24.
//

import UIKit
import SnapKit

protocol EditProfileDelegate: AnyObject {
    func presentEditProfile()
    func backToRoot()
}

final class EditProfileViewController: BaseViewController {
    weak var delegate: EditProfileDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchUserInfo()
        self.loadImage(data: UserProfileManager.shared.profile.result.profileURL)
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
            self?.delegate?.backToRoot()
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
                    if let profile = userProfileInfo as? UserProfileInfoResponse {
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
    
    // MARK: - 이미지 변환 로직
    private func loadImage(data: String) {
        guard let url = URL(string: data)  else { return }
        
        let backgroundQueue = DispatchQueue(label: "background_queue",qos: .background)
        
        backgroundQueue.async {
            guard let data = try? Data(contentsOf: url) else { return }
            
            DispatchQueue.main.async {
                self.editProfileImage.image = UIImage(data: data)
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
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(53)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-53)
        }
    }
}
