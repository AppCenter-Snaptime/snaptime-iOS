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
        label.text = "나만을 위한\n인생 네컷 커뮤니티,\nSnapTime"
        label.setLineSpacing(lineSpacing: 20)
        label.textAlignment = .left
        label.numberOfLines = 3
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        
        return label
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
                                let tk = TokenUtils()
                                tk.create(APIService.baseURL, account: "accessToken", value: token.accessToken)
                                tk.create(APIService.baseURL, account: "refreshToken", value: token.refreshToken)
                                
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
    
    private func signInLogic(loginInfo: SignInReqDto) {
        
    }
    
    // MARK: - setup UI
    override func setupLayouts() {
        super.setupLayouts()
        
        [idInputTextField,
         passwordInputTextField].forEach {
            inputStackView.addArrangedSubview($0)
        }
        
        [loginLabel,
         inputStackView,
         loginButton,
         joinButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        loginLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(100)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(43)
        }
        
        inputStackView.snp.makeConstraints {
            $0.top.equalTo(loginLabel.snp.bottom).offset(63)
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
    }
}

