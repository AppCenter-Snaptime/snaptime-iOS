//
//  JoinNameViewController.swift
//  snaptime
//
//  Created by Bowon Han on 2/1/24.
//

import UIKit
import SnapKit

protocol JoinNameViewControllerDelegate: AnyObject {
    func backToPrevious()
    func presentJoinID()
}

final class JoinNameViewController: BaseViewController {
    weak var delegate: JoinNameViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabNextButton()
        textFieldEditing()
    }
    
    // MARK: - UI component Config
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "이름과 생년월일을 입력해주세요"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        
        return label
    }()
    
    private var nameInputTextField = AuthTextField("이름")

    private var birthDateInputTextField = AuthTextField("생년월일 입력")
    private let birthDateConditionalLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textColor = .red
        
        return label
    }()

    private lazy var nextButton = SnapTimeCustomButton("다음", false)
    
    // MARK: - button click method
    private func tabNextButton() {
        nextButton.tabButtonAction = { [weak self] in
            self?.delegate?.presentJoinID()
        }
    }
    
    private func textFieldEditing() {
        [nameInputTextField, birthDateInputTextField].forEach {
            $0.delegate = self
            $0.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        }
    }

    // MARK: - setup UI
    override func setupLayouts() {
        [nameLabel,
         nameInputTextField,
         birthDateInputTextField,
         birthDateConditionalLabel,
         nextButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func setupConstraints() {
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(84)
            $0.centerX.equalToSuperview()
        }
        
        nameInputTextField.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(110)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(48)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-48)
        }
                
        birthDateInputTextField.snp.makeConstraints {
            $0.top.equalTo(nameInputTextField.snp.bottom).offset(25)
            $0.left.equalTo(nameInputTextField.snp.left)
            $0.right.equalTo(nameInputTextField.snp.right)
        }
        
        birthDateConditionalLabel.snp.makeConstraints {
            $0.top.equalTo(birthDateInputTextField.snp.bottom).offset(3)
            $0.left.equalTo(birthDateInputTextField.snp.left)
        }
        
        nextButton.snp.makeConstraints {
            $0.top.equalTo(birthDateConditionalLabel.snp.bottom).offset(44)
            $0.left.equalTo(birthDateInputTextField.snp.left)
            $0.right.equalTo(birthDateInputTextField.snp.right)
            $0.height.equalTo(50)
        }
    }
}

extension JoinNameViewController: UITextFieldDelegate {
    @objc private func textFieldEditingChanged(_ textField: UITextField) {
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        }
        
        guard
            let name = nameInputTextField.text, !name.isEmpty,
            let birthDate = birthDateInputTextField.text, !birthDate.isEmpty
        else {
            nextButton.backgroundColor = .snaptimeGray
            nextButton.isEnabled = false
            return
        }
        
        /// 날짜 형식에 맞지 않을때
        if birthDate == "123" {
            birthDateConditionalLabel.text = "생년월일 양식이 잘못되었습니다."
        }
        else {
            birthDateConditionalLabel.text = ""
            nextButton.backgroundColor = .snaptimeBlue
            nextButton.isEnabled = true
        }
    }
}
