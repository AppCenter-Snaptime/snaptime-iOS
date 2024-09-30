//
//  LoginViewController.swift
//  snaptime
//
//  Created by Bowon Han on 2/1/24.
//

import UIKit
import SnapKit
import KakaoSDKUser

protocol LoginViewControllerDelegate: AnyObject {
    func presentLogin()
    func presentHome()
    func presentJoinEmail()
}

final class LoginViewController: BaseViewController {
    weak var delegate: LoginViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideNavigationBar()
        tabLoginButton()
        textFieldEditing()
        googleButton.isHidden = true
        appleButton.isHidden = true
        
        kakaoButton.addAction(UIAction { [weak self] _ in
            self?.didTappedkakaoOAuthButton()
        }, for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.hideNavigationBar()
    }
    
    // MARK: - UI component Config
    private let loginImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .login)
        imageView.sizeToFit()
        
        return imageView
    }()
    
    private let inputStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 12
        
        return stackView
    }()
    
    private let emailInputTextField: UITextField = {
        let textField = UITextField()
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.init(hexCode: "d0d0d0").cgColor
        textField.layer.cornerRadius = 12
        textField.layer.masksToBounds = true
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        textField.leftViewMode = .always
        textField.attributedPlaceholder = NSAttributedString(string: "이메일", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(hexCode: "929292")])

        return textField
    }()
    
    private let passwordInputTextField: UITextField = {
        let textField = UITextField()
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.init(hexCode: "d0d0d0").cgColor
        textField.layer.cornerRadius = 12
        textField.layer.masksToBounds = true
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        textField.isSecureTextEntry = true
        textField.leftViewMode = .always
        textField.attributedPlaceholder = NSAttributedString(string: "비밀번호", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(hexCode: "929292")])

        return textField
    }()
    
    private let warningIdImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "exclamationmark.circle.fill")
        imageView.tintColor = .white
        
        return imageView
    }()
    
    private let warningPasswordImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "exclamationmark.circle.fill")
        imageView.tintColor = .white
        
        return imageView
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        button.isEnabled = true
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor.init(hexCode: "D3D9E0")
        button.setTitleColor(UIColor.init(hexCode: "606060"), for: .normal)
        
        return button
    }()
    
    private lazy var joinButton: UIButton = {
        let button = UIButton()
        button.setTitle("이메일로 회원가입", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        button.setTitleColor(.lightGray, for: .normal)
        button.setUnderline()
        button.addAction(UIAction { _ in
                self.tabJoinButton()
        }, for: .touchUpInside)
        
        return button
    }()
    
    private let separatedLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(hexCode: "#DBD5D0")
        view.isHidden = true
        
        return view
    }()
    
    private let oAuthLabel: UILabel = {
        let label = UILabel()
        label.text = "간편로그인"
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = UIColor.init(hexCode: "#9B9189")
        label.textAlignment = .center
        label.backgroundColor = .white
        label.isHidden = true
        
        return label
    }()
    
    private let oAuthStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 24
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    private lazy var googleButton = OAuthButton(imageName: "")
//    private lazy var kakaoButton = OAuthButton(imageName: "")
    private lazy var appleButton = OAuthButton(imageName: "")
    
    private lazy var kakaoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "kakao"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.isHidden = true
        
        return button
    }()
    
    private func textFieldEditing() {
        [emailInputTextField,
         passwordInputTextField].forEach {
            $0.delegate = self
            $0.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        }
    }
    
    private func didTappedkakaoOAuthButton() {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoTalk() success.")

                    //do something
                    _ = oauthToken
                }
            }
        }
    }
    
    private func warningLoginAlertToggle(state: Bool) {
        switch state {
        case true:
            warningIdImageView.tintColor = .white
            warningPasswordImageView.tintColor = .white
        case false:
            warningIdImageView.tintColor = .red
            warningPasswordImageView.tintColor = .red
        }
    }
    
    // MARK: - button click method
    private func tabLoginButton() {
        loginButton.addAction(UIAction {[weak self] _ in
            if let email = self?.emailInputTextField.text,
               let password = self?.passwordInputTextField.text {
                let loginInfo = SignInReqDto(email: email, password: password)
                
                LoadingService.showLoading()
                APIService.postSignIn.performRequest(with: loginInfo, responseType: CommonResponseDtoSignInResDto.self) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let result):
                            let token = KeyChain.saveTokens(accessKey: result.result.accessToken, refreshKey: result.result.refreshToken)
                                
                                /// 토큰이 keychain에 저장되었을 경우
                            if token.accessResult && token.refreshResult {
                                ProfileBasicUserDefaults().email = email
                                self?.delegate?.presentHome()
                            }
                        case .failure(let error):
                            self?.warningLoginAlertToggle(state: false)
                            print(error)
                        }
                    }
                    LoadingService.hideLoading()
                }
            }
        }, for: .touchUpInside)
    }
    
    private func tabJoinButton() {
        delegate?.presentJoinEmail()
    }
    
    // MARK: - setup UI
    override func setupLayouts() {
        super.setupLayouts()
        
        [emailInputTextField,
         passwordInputTextField].forEach {
            inputStackView.addArrangedSubview($0)
        }
        
//        [googleButton,
//         kakaoButton,
//         appleButton].forEach {
//            oAuthStackView.addArrangedSubview($0)
//        }
        
        [loginImageView,
         inputStackView,
         warningIdImageView,
         warningPasswordImageView,
         loginButton,
         joinButton,
         separatedLine,
         oAuthLabel,
        kakaoButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        loginImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(120)
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(80)
            $0.width.equalTo(110)
        }
        
        [emailInputTextField, passwordInputTextField].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(48)
            }
        }
        
        warningIdImageView.snp.makeConstraints {
            $0.right.equalTo(emailInputTextField.snp.right).offset(-20)
            $0.centerY.equalTo(emailInputTextField.snp.centerY)
            $0.width.height.equalTo(16)
        }
        
        warningPasswordImageView.snp.makeConstraints {
            $0.right.equalTo(passwordInputTextField.snp.right).offset(-20)
            $0.centerY.equalTo(passwordInputTextField.snp.centerY)
            $0.width.height.equalTo(16)
        }
        
        inputStackView.snp.makeConstraints {
            $0.top.equalTo(loginImageView.snp.bottom).offset(50)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(46)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-46)
        }
                
        loginButton.snp.makeConstraints {
            $0.top.equalTo(inputStackView.snp.bottom).offset(56)
            $0.left.equalTo(inputStackView.snp.left)
            $0.right.equalTo(inputStackView.snp.right)
            $0.height.equalTo(50)
        }
        
        joinButton.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(33)
            $0.centerX.equalToSuperview()
        }
        
        separatedLine.snp.makeConstraints {
            $0.top.equalTo(joinButton.snp.bottom).offset(60)
            $0.left.equalTo(inputStackView.snp.left)
            $0.right.equalTo(inputStackView.snp.right)
            $0.height.equalTo(1)
        }
        
        oAuthLabel.snp.makeConstraints {
            $0.center.equalTo(separatedLine)
            $0.width.equalTo(70)
        }
        
        kakaoButton.snp.makeConstraints {
            $0.top.equalTo(separatedLine.snp.bottom).offset(40)
            $0.left.right.equalTo(view.safeAreaLayoutGuide).inset(46)
            $0.height.equalTo(50)
        }
        
//        oAuthStackView.snp.makeConstraints {
//            $0.top.equalTo(separatedLine.snp.bottom).offset(40)
//            $0.centerX.equalTo(view.safeAreaLayoutGuide)
//        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    @objc private func textFieldEditingChanged(_ textField: UITextField) {
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        }
        
        guard
            let id = emailInputTextField.text, !id.isEmpty,
            let password = passwordInputTextField.text, !password.isEmpty, password.count >= 8
        else {
            loginButton.backgroundColor = UIColor.init(hexCode: "D3D9E0")
            loginButton.setTitleColor(UIColor.init(hexCode: "606060") , for: .normal)
            loginButton.isEnabled = false
            return
        }
        loginButton.backgroundColor = .snaptimeBlue
        loginButton.setTitleColor(.white , for: .normal)
        loginButton.isEnabled = true
        warningLoginAlertToggle(state: true)
    }
}
