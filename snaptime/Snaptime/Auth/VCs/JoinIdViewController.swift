//
//  File.swift
//  snaptime
//
//  Created by Bowon Han on 2/1/24.
//

import UIKit
import SnapKit

protocol JoinIdViewControllerDelegate: AnyObject {
    func backToPrevious()
    func backToRoot()
}

final class JoinIdViewController: BaseViewController {
    weak var delegate: JoinIdViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        tabNextButton()
        textFieldEditing()
        self.hideKeyboardWhenTappedAround()
    }
    
    // MARK: - UI component Config
    private let idLabel: UILabel = {
        let label = UILabel()
        label.text = "사용하실 아이디를 입력해주세요"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textAlignment = .center
        
        return label
    }()
    
    private var idInputTextField = AuthTextField("@snaptime123")
    private let idConditionalLabel: UILabel = {
        let label = UILabel()
        label.text = "소문자 영어와 숫자로 구성해주세요"
        label.font = .systemFont(ofSize: 10)
        
        return label
    }()
    
    private lazy var nextButton = SnapTimeCustomButton("다음", false)
    
    // MARK: - button click method
    private func tabNextButton() {
        nextButton.addAction(UIAction {[weak self] _ in
            self?.delegate?.backToRoot()
        }, for: .touchUpInside)
    }
    
    private func textFieldEditing() {
        idInputTextField.delegate = self
        idInputTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
    }

    // MARK: - setup UI
    override func setupLayouts() {
        [idLabel,
         idInputTextField,
         idConditionalLabel,
         nextButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func setupConstraints() {
        idLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(84)
            $0.centerX.equalToSuperview()
        }
        
        idInputTextField.snp.makeConstraints {
            $0.top.equalTo(idLabel.snp.bottom).offset(106)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(48)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-48)
        }
        
        idConditionalLabel.snp.makeConstraints {
            $0.top.equalTo(idInputTextField.snp.bottom).offset(3)
            $0.left.equalTo(idInputTextField.snp.left)
        }
        
        nextButton.snp.makeConstraints {
            $0.top.equalTo(idConditionalLabel.snp.bottom).offset(58)
            $0.left.equalTo(idInputTextField.snp.left)
            $0.right.equalTo(idInputTextField.snp.right)
            $0.height.equalTo(50)
        }
    }
}

extension JoinIdViewController: UITextFieldDelegate {
    @objc private func textFieldEditingChanged(_ textField: UITextField) {
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        }
         
        guard
            let id = idInputTextField.text, !id.isEmpty
        else {
            nextButton.backgroundColor = .snaptimeGray
            nextButton.isEnabled = false
            idInputTextField.setLineColorFalse()
            return
        }
        nextButton.backgroundColor = .snaptimeBlue
        nextButton.isEnabled = true
        idInputTextField.setLineColorTrue()
    }
}
