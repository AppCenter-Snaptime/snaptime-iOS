//
//  LoginViewController.swift
//  snaptime
//
//  Created by Bowon Han on 2/1/24.
//

import UIKit
import SnapKit

protocol LoginNavigation : AnyObject {
    func presentLogin()
    func presentHome()
    func presentJoinEmail()
}

final class LoginViewController : BaseViewController {
    weak var coordinator : LoginNavigation?
    
    init(coordinator: LoginNavigation) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - UI component Config
    private let loginLabel : UILabel = {
        let label = UILabel()
        label.text = "나만을 위한 인생 네컷 앨범📸"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        
        return label
    }()
    
    private let inputStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 10
        
        return stackView
    }()
    
    private let idInputTextField = AuthTextField("아이디 또는 이메일")
    private let passwordInputTextField = AuthTextField("비밀번호")
    
    private lazy var loginButton : UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        button.layer.cornerRadius = 10
        button.backgroundColor = .lightGray
        button.setTitle("로그인", for: .normal)
        button.addAction(
            UIAction { _ in
                self.tabLoginButton()
            }, for: .touchUpInside)

        return button
    }()
    
    private lazy var joinButton : UIButton = {
        let button = UIButton()
        button.setTitle("이메일로 회원가입", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        button.setTitleColor(.lightGray, for: .normal)
        button.addAction(
            UIAction { _ in
                self.tabJoinButton()
        }, for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - button click method
    @objc private func tabLoginButton() {
        coordinator?.presentHome()
    }
    
    private func tabJoinButton() {
        coordinator?.presentJoinEmail()
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
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(45)
        }
        
        inputStackView.snp.makeConstraints {
            $0.top.equalTo(loginLabel.snp.bottom).offset(100)
            $0.centerX.equalToSuperview()
        }
                
        loginButton.snp.makeConstraints {
            $0.top.equalTo(inputStackView.snp.bottom).offset(64)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(300)
            $0.height.equalTo(50)
        }
        
        joinButton.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
    }
}

