//
//  LoginViewController.swift
//  snaptime
//
//  Created by Bowon Han on 2/1/24.
//

import UIKit
import SnapKit

final class LoginViewController : BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
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
    
    private lazy var loginButton = AuthButton("로그인")
    
    private lazy var joinButton : UIButton = {
        let button = UIButton()
        button.setTitle("이메일로 회원가입", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        button.setTitleColor(.lightGray, for: .normal)
        
        return button
    }()
    
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
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(140)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(45)
        }
        
        inputStackView.snp.makeConstraints {
            $0.top.equalTo(loginLabel.snp.bottom).offset(100)
            $0.centerX.equalToSuperview()
        }
                
        loginButton.snp.makeConstraints {
            $0.top.equalTo(inputStackView.snp.bottom).offset(64)
            $0.centerX.equalToSuperview()
        }
        
        joinButton.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
    }
}

