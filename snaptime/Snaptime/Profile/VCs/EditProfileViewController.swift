//
//  EditProfileViewController.swift
//  snaptime
//
//  Created by Bowon Han on 2/1/24.
//

import UIKit
import SnapKit
import Kingfisher
import Alamofire

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

        [editProfileImage, 
         editProfileImageButton].forEach {
            $0.layer.cornerRadius = $0.frame.height/2
            $0.clipsToBounds = true
        }
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
        button.addAction(UIAction { [weak self] _ in
            self?.tabImageButton(tag: 1)
        }, for: .touchUpInside)
        
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
            if let nickName = self?.editNickNameTextField.editTextField.text,
               let email = self?.editEmailTextField.editTextField.text,
               let name = self?.editNameTextField.editTextField.text {
                let param = UserUpdateDto(name: name, nickName: nickName)
                
                Task {
                    await self?.modifyProfileImage()
                    self?.delegate?.backToRoot()
                }
            }
        }, for: .touchUpInside)
        
        return button
    }()
    
    private let editNickNameTextField = EditProfileTextField("닉네임")
    private let editEmailTextField = EditProfileTextField("이메일", isEnabledEdit: false)
    private let editNameTextField = EditProfileTextField("이름")
    
    private func tabImageButton(tag: Int) {
        let imagePicker = UIImagePickerController()

        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true

        imagePicker.view.tag = tag

        self.present(imagePicker, animated: true)
    }
    
    // MARK: - 사용자 정보 서버에서 불러오기
    private func fetchUserInfo() {
        APIService.fetchUserInfo.performRequest(responseType: CommonResponseDtoUserFindResDto.self) { result in
            switch result {
            case .success(let userProfileInfo):
                DispatchQueue.main.async {
                    self.editNickNameTextField.editTextField.text = userProfileInfo.result.nickName
                    self.editEmailTextField.editTextField.text = userProfileInfo.result.email
                    self.editNameTextField.editTextField.text = userProfileInfo .result.name
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func modifyUserInfo(userInfo: UserUpdateDto) {
        APIService.modifyUserInfo.performRequest(with: userInfo, responseType: CommonResDtoVoid.self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let result):
                    print(result.msg)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func modifyProfileImage() async {
        let url = "http://na2ru2.me:6308/profile-photos"
        guard let token = KeyChain.loadAccessToken(key: TokenType.accessToken.rawValue) else { return }
        
        var headers: HTTPHeaders {
            ["Authorization": "Bearer \(token)", "accept": "*/*", "Content-Type": "multipart/form-data"]
        }
        
        guard let image = editProfileImage.image,
              let jpgimageData = image.jpegData(compressionQuality: 0.2)
        else { return }
        
        let response = await AF
            .upload(multipartFormData: { multipartFormData in
                multipartFormData.append(jpgimageData, 
                                         withName: "file",
                                         fileName: "image.png",
                                         mimeType: "image/jpeg")
                }, to: url,
                    method: .put,
                    headers: headers)
            .serializingDecodable(CommonResponseDtoModifyUserInfoResDto.self)
            .response

        switch response.result {
        case .success(let res):
            if (400..<599).contains(response.response?.statusCode ?? 0) {
                print("error - ", res.msg)
            }
            else {
                print("프로필 이미지 수정 완료")
                
                DispatchQueue.main.async {
                    print(res.result)
                    let profileUrl = "http://na2ru2.me:6308/profile-photos/" + String(res.result.profilePhotoId)
                    UserProfileManager.shared.profile.result.profileURL = profileUrl
                }
            }
        case .failure(let error):
            print(error)
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
         
        [editNickNameTextField,
         editEmailTextField,
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

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: false) { () in
            let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
            
            if let tag = picker.view?.tag {
                switch tag {
                case 1:
                    self.editProfileImage.image = image
                default:
                    break
                }
            }
        }
    }
}
