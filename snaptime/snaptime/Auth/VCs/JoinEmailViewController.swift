//
//  JoinEmailViewController.swift
//  snaptime
//
//  Created by Bowon Han on 2/1/24.
//

import UIKit
import SnapKit

protocol JoinEmailNavigation : AnyObject {
    func backToPrevious()
    func presentJoinPassword()
}

final class JoinEmailViewController : BaseViewController {
    weak var coordinator : JoinEmailNavigation?
    
    init(coordinator: JoinEmailNavigation) {
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
    private let emailLabel : UILabel = {
        let label = UILabel()
        label.text = "사용하실 이메일 주소를 입력해주세요"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        
        return label
    }()
    
    private var emailInputTextField = AuthTextField("abc@example.com")
    
//    private lazy var nextButton = AuthButton("다음")
    private lazy var nextButton : UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        button.layer.cornerRadius = 10
        button.backgroundColor = .snaptimeBlue
        button.setTitle("다음", for: .normal)
        button.addAction(
            UIAction { _ in
                self.tabNextButton()
            }, for: .touchUpInside)

        return button
    }()
    
    // MARK: - button click method
    private func tabNextButton() {
        coordinator?.presentJoinPassword()
    }
    
    // MARK: - setup UI
    override func setupLayouts() {
        [emailLabel,emailInputTextField,nextButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func setupConstraints() {
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(130)
            $0.centerX.equalToSuperview()
        }
        
        emailInputTextField.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(110)
            $0.centerX.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.top.equalTo(emailInputTextField.snp.bottom).offset(70)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(300)
            $0.height.equalTo(50)
        }
    }
}
