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
    func presentJoinName()
}

final class JoinPasswordViewController: BaseViewController {
    weak var delegate: JoinPasswordViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        tabNextButton()
    }
    
    // MARK: - UI component Config
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "사용하실 비밀번호를 입력해주세요"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        
        return label
    }()
    
    private var passwordInputTextField = AuthTextField("비밀번호")
    private let passwordConditionalLabel: UILabel = {
        let label = UILabel()
        label.text = "8~10자의 영문, 숫자를 조합해주세요"
        label.font = .systemFont(ofSize: 10)
        label.textColor = .blue
        
        return label
    }()
    
    private var passwordCheckInputTextField = AuthTextField("비밀번호 재입력")
    private let passwordCheckConditionalLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호가 일치하지 않습니다"
        label.font = .systemFont(ofSize: 10)
        label.textColor = .red
        
        return label
    }()
    
    private lazy var nextButton = SnapTimeCustomButton("다음")
    
    // MARK: - button click method
    private func tabNextButton() {
        nextButton.tabButtonAction = { [weak self] in
            self?.delegate?.presentJoinName()
        }
    }
    
    // MARK: - setup UI
    override func setupLayouts() {
        [passwordLabel,
         passwordInputTextField,
         passwordConditionalLabel,
         passwordCheckInputTextField,
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
        
        passwordConditionalLabel.snp.makeConstraints {
            $0.top.equalTo(passwordInputTextField.snp.bottom).offset(3)
            $0.left.equalTo(passwordInputTextField.snp.left)
        }
        
        passwordCheckInputTextField.snp.makeConstraints {
            $0.top.equalTo(passwordInputTextField.snp.bottom).offset(40)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(48)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-48)
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
