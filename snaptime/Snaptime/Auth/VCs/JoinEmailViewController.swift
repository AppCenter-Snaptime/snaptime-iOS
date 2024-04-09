//
//  JoinEmailViewController.swift
//  snaptime
//
//  Created by Bowon Han on 2/1/24.
//

import UIKit
import SnapKit

protocol JoinEmailViewControllerDelegate: AnyObject {
    func backToPrevious()
    func presentJoinPassword()
}

final class JoinEmailViewController: BaseViewController {
    weak var delegate: JoinEmailViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabNextButton()
        textFieldEditing()
    }
    
    // MARK: - UI component Config
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "사용하실 이메일 주소를 입력해주세요"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        
        return label
    }()
    
    private var emailInputTextField = AuthTextField("abc@example.com")

    private lazy var nextButton = SnapTimeCustomButton("다음", false)
    
    // MARK: - button click method
    private func tabNextButton() {
        nextButton.tabButtonAction = { [weak self] in
            self?.delegate?.presentJoinPassword()
        }
    }
    
    private func textFieldEditing() {
        emailInputTextField.delegate = self
        emailInputTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
    }
    
    // MARK: - setup UI
    override func setupLayouts() {
        [emailLabel,
         emailInputTextField,
         nextButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func setupConstraints() {
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(84)
            $0.centerX.equalToSuperview()
        }
        
        emailInputTextField.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(110)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(48)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-48)
        }
        
        nextButton.snp.makeConstraints {
            $0.top.equalTo(emailInputTextField.snp.bottom).offset(70)
            $0.left.equalTo(emailInputTextField.snp.left)
            $0.right.equalTo(emailInputTextField.snp.right)
            $0.height.equalTo(50)
        }
    }
}

extension JoinEmailViewController: UITextFieldDelegate {
    @objc private func textFieldEditingChanged(_ textField: UITextField) {
        if self.emailInputTextField.text?.count == 1 {
            if emailInputTextField.text?.first == " " {
                emailInputTextField.text = ""
                return
            }
        }
        guard
            let email = self.emailInputTextField.text, !email.isEmpty
        else {
            nextButton.backgroundColor = .snaptimeGray
            nextButton.isEnabled = false
            emailInputTextField.setLineColorFalse()
            return
        }
        nextButton.backgroundColor = .snaptimeBlue
        nextButton.isEnabled = true
        emailInputTextField.setLineColorTrue()
    }
}
