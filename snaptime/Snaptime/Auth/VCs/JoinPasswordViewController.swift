//
//  JoinPasswordViewController.swift
//  snaptime
//
//  Created by Bowon Han on 2/1/24.
//

import UIKit
import SnapKit

protocol JoinPasswordNavigation : AnyObject {
    func backToPrevious()
    func presentName()
}

class JoinPasswordViewController : BaseViewController {
    weak var coordinator : JoinPasswordNavigation?
    
    init(coordinator: JoinPasswordNavigation) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tabNextButton()
    }
    
    // MARK: - UI component Config
    private let passwordLabel : UILabel = {
        let label = UILabel()
        label.text = "사용하실 비밀번호를 입력해주세요"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        
        return label
    }()
    
    private var passwordInputTextField = AuthTextField("비밀번호")
    private let passwordConditionalLabel : UILabel = {
        let label = UILabel()
        label.text = "8~10자의 영문, 숫자를 조합해주세요"
        label.font = .systemFont(ofSize: 10)
        label.textColor = .blue
        
        return label
    }()
    
    private var passwordCheckInputTextField = AuthTextField("비밀번호 재입력")
    private let passwordCheckConditionalLabel : UILabel = {
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
            self?.coordinator?.presentName()
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
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(130)
            $0.centerX.equalToSuperview()
        }
        
        passwordInputTextField.snp.makeConstraints {
            $0.top.equalTo(passwordLabel.snp.bottom).offset(110)
            $0.centerX.equalToSuperview()
        }
        
        passwordConditionalLabel.snp.makeConstraints {
            $0.top.equalTo(passwordInputTextField.snp.bottom).offset(3)
            $0.left.equalTo(passwordInputTextField.snp.left)
        }
        
        passwordCheckInputTextField.snp.makeConstraints {
            $0.top.equalTo(passwordInputTextField.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
        }
        
        passwordCheckConditionalLabel.snp.makeConstraints {
            $0.top.equalTo(passwordCheckInputTextField.snp.bottom).offset(3)
            $0.left.equalTo(passwordCheckInputTextField.snp.left)
        }
        
        nextButton.snp.makeConstraints {
            $0.top.equalTo(passwordCheckInputTextField.snp.bottom).offset(70)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(300)
            $0.height.equalTo(50)
        }
    }
}
