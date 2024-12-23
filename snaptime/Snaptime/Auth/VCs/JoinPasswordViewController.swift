//
//  JoinPasswordViewController.swift
//  snaptime
//
//  Created by Bowon Han on 2/1/24.
//

import UIKit
import SnapKit

protocol JoinPasswordViewControllerDelegate: AnyObject {
    func backToPrevious()
    func presentJoinName(info: SignUpReqDto)
}

final class JoinPasswordViewController: BaseViewController {
    weak var delegate: JoinPasswordViewControllerDelegate?
    
    private var registrationInfo: SignUpReqDto

    override func viewDidLoad() {
        super.viewDidLoad()
        tabNextButton()
        textFieldEditing()
    }
    
    init(info: SignUpReqDto) {
        self.registrationInfo = info
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI component Config
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "사용하실 비밀번호를 입력해주세요"
        label.textAlignment = .center
        label.font = UIFont(name: SuitFont.semiBold, size: 20)
        
        return label
    }()
    
    private var passwordInputTextField = AuthTextField("비밀번호", secureToggle: true)
    private lazy var passwordSecureButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.tintColor = UIColor.init(hexCode: "475569")
        button.addAction(UIAction{ _ in
            self.tapPassWordSecureModeSetting(textField: self.passwordInputTextField)
        }, for: .touchUpInside)
        
        return button
    }()
    
    private let passwordConditionalLabel: UILabel = {
        let label = UILabel()
        label.text = "8~10자의 영문, 숫자를 조합해주세요"
        label.font = UIFont(name: SuitFont.medium, size: 10)
        label.textColor = .init(hexCode: "3B6DFF")
        
        return label
    }()
    
    private var passwordCheckInputTextField = AuthTextField("비밀번호 재입력",secureToggle: true)
    private lazy var passwordCheckSecureButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.tintColor = UIColor.init(hexCode: "475569")
        button.addAction(UIAction{ _ in
            self.tapPassWordSecureModeSetting(textField: self.passwordCheckInputTextField)
        }, for: .touchUpInside)
        
        return button
    }()
    
    private let passwordCheckConditionalLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = UIFont(name: SuitFont.medium, size: 10)
        
        return label
    }()
    
    private lazy var nextButton = SnapTimeCustomButton("다음", false)
    
    // MARK: - button click method
    private func tabNextButton() {
        nextButton.addAction(UIAction {[weak self] _ in
            self?.registrationInfo.password = self?.passwordInputTextField.text
            
            if let info = self?.registrationInfo {
                self?.delegate?.presentJoinName(info: info)
            }
        }, for: .touchUpInside)
    }
    
    /// Switch password secure mode
    private func tapPassWordSecureModeSetting(textField: AuthTextField) {
        textField.isSecureTextEntry.toggle()
    }
    
    private func textFieldEditing() {
        [passwordInputTextField, 
         passwordCheckInputTextField].forEach {
            $0.delegate = self
            $0.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        }
    }
    
    // MARK: - setup UI
    override func setupLayouts() {
        [passwordLabel,
         passwordInputTextField,
         passwordSecureButton,
         passwordConditionalLabel,
         passwordCheckInputTextField,
         passwordCheckSecureButton,
         passwordCheckConditionalLabel,
         nextButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func setupConstraints() {
        passwordLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(84)
            $0.centerX.equalToSuperview()
        }
        
        passwordInputTextField.snp.makeConstraints {
            $0.top.equalTo(passwordLabel.snp.bottom).offset(64)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(48)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-48)
        }
        
        passwordSecureButton.snp.makeConstraints {
            $0.centerY.equalTo(passwordInputTextField.snp.centerY)
            $0.right.equalTo(passwordInputTextField.snp.right).offset(-5)
            $0.height.equalTo(20)
        }
        
        passwordConditionalLabel.snp.makeConstraints {
            $0.top.equalTo(passwordInputTextField.snp.bottom).offset(3)
            $0.left.equalTo(passwordInputTextField.snp.left).offset(8)
        }
        
        passwordCheckInputTextField.snp.makeConstraints {
            $0.top.equalTo(passwordInputTextField.snp.bottom).offset(49)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(48)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-48)
        }
        
        passwordCheckSecureButton.snp.makeConstraints {
            $0.centerY.equalTo(passwordCheckInputTextField.snp.centerY)
            $0.right.equalTo(passwordCheckInputTextField.snp.right).offset(-5)
            $0.height.equalTo(20)
        }
        
        passwordCheckConditionalLabel.snp.makeConstraints {
            $0.top.equalTo(passwordCheckInputTextField.snp.bottom).offset(3)
            $0.left.equalTo(passwordCheckInputTextField.snp.left)
        }
        
        nextButton.snp.makeConstraints {
            $0.top.equalTo(passwordCheckConditionalLabel.snp.bottom).offset(44)
            $0.left.equalTo(passwordCheckInputTextField.snp.left)
            $0.right.equalTo(passwordCheckInputTextField.snp.right)
            $0.height.equalTo(50)
        }
    }
}

extension JoinPasswordViewController: UITextFieldDelegate {
    @objc private func textFieldEditingChanged(_ textField: UITextField) {
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        }
        
        guard
            let password = passwordInputTextField.text, password.isValidPassword,
            let passwordCheck = passwordCheckInputTextField.text, passwordCheck.isValidPassword,
            password == passwordCheck
        else {
            passwordCheckConditionalLabel.text = "비밀번호가 일치하지 않습니다."
            nextButton.backgroundColor = .snaptimeGray
            nextButton.isEnabled = false
            return
        }
        passwordCheckConditionalLabel.text = ""
        nextButton.backgroundColor = .snaptimeBlue
        nextButton.isEnabled = true
    }
}
