//
//  JoinEmailViewController.swift
//  snaptime
//
//  Created by Bowon Han on 2/1/24.
//

import UIKit
import SnapKit
import Alamofire

protocol JoinEmailViewControllerDelegate: AnyObject {
    func backToPrevious()
    func presentJoinPassword(info: SignUpReqDto)
}

final class JoinEmailViewController: BaseViewController {
    weak var delegate: JoinEmailViewControllerDelegate?
    
    private var registrationInfo: SignUpReqDto?

    override func viewDidLoad() {
        super.viewDidLoad()
        tabNextButton()
        textFieldEditing()
        self.showNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailInputTextField.text = ""
        nextButton.backgroundColor = .snaptimeGray
        nextButton.isEnabled = false
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
    private var emailVerfiedInputTextField = AuthTextField("인증번호를 입력하세요.")
    
    private lazy var sendEmailVerfiedNumberButton: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.filled()
        config.baseForegroundColor = .white
        config.baseBackgroundColor = .snaptimeBlue
        
        var titleAttr = AttributedString.init("전송")
        titleAttr.font = .systemFont(ofSize: 14, weight: .bold)
        config.attributedTitle = titleAttr
        
        button.configuration = config
        button.addAction(UIAction {[weak self] _ in
            guard let email = self?.emailInputTextField.text else { return }
            
            APIService.postSendEmailCode(email: email).performRequest(responseType: CommonResDtoVoid.self) { result in
                switch result {
                case .success(let success):
                    break
                case .failure(let failure):
                    let errorMessage = failure.localizedDescription
                    
                    self?.show(
                        alertText: errorMessage,
                        cancelButtonText: "아니오",
                        confirmButtonText: "예",
                        identifier: "failSendEmail"
                    )
                }
            }
        }, for: .touchUpInside)
        
        return button
    }()
    
    private lazy var emailVerfiedButton: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.filled()
        config.baseForegroundColor = .white
        config.baseBackgroundColor = .snaptimeBlue
        
        var titleAttr = AttributedString.init("인증")
        titleAttr.font = .systemFont(ofSize: 14, weight: .bold)
        config.attributedTitle = titleAttr
        
        button.configuration = config
        button.addAction(UIAction {[weak self] _ in
            guard let email = self?.emailInputTextField.text else { return }
            guard let code = self?.emailVerfiedInputTextField.text else { return }
            
            APIService.postEmailVerfied(email: email, code: code).performRequest(responseType: CommonResDtoVoid.self) { result in
                switch result {
                case .success(let success):
                    break
                case .failure(let failure):
                    let errorMessage = failure.localizedDescription

                    print("에러 발생: \(errorMessage)")
                    
                    self?.show(
                        alertText: errorMessage,
                        cancelButtonText: "아니오",
                        confirmButtonText: "예",
                        identifier: "failVerifyEmail"
                    )
                }
            }
        }, for: .touchUpInside)
        
        return button
    }()

    private lazy var nextButton = SnapTimeCustomButton("다음", false)
    
    // MARK: - button click method
    private func tabNextButton() {
        nextButton.addAction(UIAction {[weak self] _ in
            let info = SignUpReqDto(email: self?.emailInputTextField.text)
            
            print(info)
            self?.delegate?.presentJoinPassword(info: info)
        }, for: .touchUpInside)
    }
    
    private func textFieldEditing() {
        emailInputTextField.keyboardType = UIKeyboardType.emailAddress
        emailInputTextField.delegate = self
        emailInputTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
    }
    
    // MARK: - setup UI
    override func setupLayouts() {
        [emailLabel,
         emailInputTextField,
         emailVerfiedInputTextField,
         sendEmailVerfiedNumberButton,
         emailVerfiedButton,
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
            $0.left.right.equalTo(view.safeAreaLayoutGuide).inset(48)
        }
        
        sendEmailVerfiedNumberButton.snp.makeConstraints {
            $0.right.equalTo(emailInputTextField.snp.right).inset(15)
            $0.top.bottom.equalTo(emailInputTextField).inset(10)
            $0.width.equalTo(sendEmailVerfiedNumberButton.snp.height).multipliedBy(1.7)
        }
        
        emailVerfiedInputTextField.snp.makeConstraints {
            $0.top.equalTo(emailInputTextField.snp.bottom).offset(15)
            $0.left.right.equalTo(emailInputTextField)
        }
        
        emailVerfiedButton.snp.makeConstraints {
            $0.right.equalTo(emailVerfiedInputTextField.snp.right).inset(15)
            $0.top.bottom.equalTo(emailVerfiedInputTextField).inset(10)
            $0.width.equalTo(emailVerfiedButton.snp.height).multipliedBy(1.7)
        }
        
        nextButton.snp.makeConstraints {
            $0.top.equalTo(emailVerfiedInputTextField.snp.bottom).offset(70)
            $0.left.equalTo(emailVerfiedInputTextField.snp.left)
            $0.right.equalTo(emailVerfiedInputTextField.snp.right)
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
        
        guard let email = self.emailInputTextField.text,
                !email.isEmpty,
                email.isValidEmail
        else {
            nextButton.backgroundColor = .snaptimeGray
            nextButton.isEnabled = false
            return
        }
        nextButton.backgroundColor = .snaptimeBlue
        nextButton.isEnabled = true
    }
}

extension JoinEmailViewController: CustomAlertDelegate {
    func action(identifier: String) {
        
    }
    
    func exit(identifier: String) {}
}
