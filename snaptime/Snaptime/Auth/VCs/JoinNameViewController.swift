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
    func presentJoinID(info: SignUpReqDto)
}

final class JoinNameViewController: BaseViewController {
    weak var delegate: JoinNameViewControllerDelegate?
    
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
        nextButton.addAction(UIAction {[weak self] _ in
            self?.registrationInfo.name = self?.nameInputTextField.text
            self?.registrationInfo.birthDay = self?.birthDateInputTextField.text
            
            if let info = self?.registrationInfo {
                self?.delegate?.presentJoinID(info: info)
            }
        }, for: .touchUpInside)
    }
    
    private func textFieldEditing() {
        nameInputTextField.keyboardType = UIKeyboardType.default
        
        birthDateInputTextField.keyboardType = UIKeyboardType.numberPad

        [nameInputTextField, 
         birthDateInputTextField].forEach {
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
            $0.left.equalTo(birthDateInputTextField.snp.left).offset(9)
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
        guard let name = nameInputTextField.text, !name.isEmpty else {
            nextButton.backgroundColor = .snaptimeGray
            nextButton.isEnabled = false
            return
        }
        
        guard let birthDate = birthDateInputTextField.text else { return }

        if birthDate.isVaildDate {
            birthDateConditionalLabel.text = ""
            nextButton.backgroundColor = .snaptimeBlue
            nextButton.isEnabled = true
        } else {
            birthDateConditionalLabel.text = "생년월일 양식이 잘못되었습니다."
            nextButton.backgroundColor = .snaptimeGray
            nextButton.isEnabled = false
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == birthDateInputTextField {
            
            /// 생년월일 작성 시 0000.00.00 로 형식 변경해주는 기능
            let currentText = textField.text ?? ""
            let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)

            if string.isEmpty {
                return true
            }

            let allowedCharacterSet = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            if !allowedCharacterSet.isSuperset(of: characterSet) {
                return false
            }

            var formattedText = updatedText.replacingOccurrences(of: ".", with: "")
            if formattedText.count > 8 {
                return false
            }
            if formattedText.count > 4 {
                formattedText.insert(".", at: formattedText.index(formattedText.startIndex, offsetBy: 4))
            }
            if formattedText.count > 7 {
                formattedText.insert(".", at: formattedText.index(formattedText.startIndex, offsetBy: 7))
            }

            textField.text = formattedText
            textField.sendActions(for: .editingChanged)
            return false
        }
        
        return true
    }
}
