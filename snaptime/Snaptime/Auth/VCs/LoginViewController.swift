//
//  LoginViewController.swift
//  snaptime
//
//  Created by Bowon Han on 2/1/24.
//

import UIKit
import SnapKit

protocol LoginViewControllerDelegate: AnyObject {
    func presentLogin()
    func presentHome()
    func presentJoinEmail()
}

final class LoginViewController: BaseViewController {
    weak var delegate: LoginViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabLoginButton()
        self.hideKeyboardWhenTappedAround()
    }
    
    // MARK: - UI component Config
    private let loginLabel: UILabel = {
        let label = UILabel()
        label.text = "나만을 위한\n인생 네컷 커뮤니티,"
        label.setLineSpacing(lineSpacing: 20)
        label.textAlignment = .left
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.sizeToFit()
        
        return label
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .logo)
        imageView.sizeToFit()
        
        return imageView
    }()
    
    private let inputStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 35
        
        return stackView
    }()
    
    private let idInputTextField = AuthTextField("아이디 또는 이메일")
    private let passwordInputTextField = AuthTextField("비밀번호", secureToggle: true)
    
    private lazy var loginButton = SnapTimeCustomButton("로그인")
    
    private lazy var joinButton: UIButton = {
        let button = UIButton()
        button.setTitle("이메일로 회원가입", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        button.setTitleColor(.lightGray, for: .normal)
        button.addAction(UIAction { _ in
                self.tabJoinButton()
        }, for: .touchUpInside)
        
        return button
    }()
    
    private let separatedLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(hexCode: "#DBD5D0")
        
        return view
    }()
    
    private let oAuthLabel: UILabel = {
        let label = UILabel()
        label.text = "간편로그인"
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = UIColor.init(hexCode: "#9B9189")
        label.textAlignment = .center
        label.backgroundColor = .white
        
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
    private lazy var kakaoButton = OAuthButton(imageName: "")
    private lazy var appleButton = OAuthButton(imageName: "")
    
    // MARK: - button click method
    private func tabLoginButton() {
        loginButton.addAction(UIAction {[weak self] _ in
            if let id = self?.idInputTextField.text,
               let password = self?.passwordInputTextField.text {
                let loginInfo = SignInReqDto(loginId: id, password: password)
                
                APIService.signIn.performRequest(with: loginInfo) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let token):
                            if let token = token as? SignInResDto {
                                KeyChain.saveTokens(accessKey: token.accessToken, refreshKey: token.refreshToken)
                                
//                                ProfileBasicManager.shared.profile.loginId = id
                                
                                self?.delegate?.presentHome()
                            }
                        case .failure(let error):
                            print(error)
                        }
                    }
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
        
        [idInputTextField,
         passwordInputTextField].forEach {
            inputStackView.addArrangedSubview($0)
        }
        
        [googleButton,
         kakaoButton,
         appleButton].forEach {
            oAuthStackView.addArrangedSubview($0)
        }
        
        [loginLabel,
         logoImageView,
         inputStackView,
         loginButton,
         joinButton,
         separatedLine,
         oAuthLabel,
         oAuthStackView].forEach {
            view.addSubview($0)
        }
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        loginLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(43)
        }
        
        logoImageView.snp.makeConstraints {
            $0.top.equalTo(loginLabel.snp.bottom).offset(20)
            $0.left.equalTo(loginLabel.snp.left)
            $0.height.equalTo(30)
            $0.width.equalTo(130)
        }
        
        inputStackView.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(50)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(46)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-46)
        }
                
        loginButton.snp.makeConstraints {
            $0.top.equalTo(inputStackView.snp.bottom).offset(64)
            $0.left.equalTo(inputStackView.snp.left)
            $0.right.equalTo(inputStackView.snp.right)
            $0.height.equalTo(50)
        }
        
        joinButton.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(32)
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
        
        oAuthStackView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-80)
            $0.top.equalTo(separatedLine.snp.bottom).offset(30)
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

