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
    func backToRoot()
    func presentLogin()
    func backToSpecificVC(_ vc: UIViewController)
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
        label.text = "이름을 입력해주세요"
        label.textAlignment = .center
        label.font = UIFont(name: SuitFont.semiBold, size: 20)
        
        return label
    }()
    
    private var nameInputTextField = AuthTextField("이름")
    private lazy var nextButton = SnapTimeCustomButton("다음", true)
    
    // MARK: - button click method
    private func tabNextButton() {
        nextButton.addAction(UIAction {[weak self] _ in
            self?.registrationInfo.name = self?.nameInputTextField.text
            
            guard let info = self?.registrationInfo else { return }
            self?.postSignUp(info: info)
           
        }, for: .touchUpInside)
    }
    
    private func postSignUp(info: SignUpReqDto) {
        APIService.postSignUp.performRequest(with: info, responseType: CommonResDtoVoid.self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self.delegate?.presentLogin()
                case .failure(let error):
                    print(error)
                    self.show(
                        alertText: "회원가입 실패. 다시 시도하시겠습니까?",
                        cancelButtonText: "아니오",
                        confirmButtonText: "예",
                        identifier: "failSignUp"
                    )
                    print(error)
                }
            }
        }
    }
    
    private func textFieldEditing() {
        nameInputTextField.keyboardType = UIKeyboardType.default
        
//        nameInputTextField.delegate = self
//        nameInputTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
    }

    // MARK: - setup UI
    override func setupLayouts() {
        [nameLabel,
         nameInputTextField,
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
        
        nextButton.snp.makeConstraints {
            $0.top.equalTo(nameInputTextField.snp.bottom).offset(44)
            $0.left.equalTo(nameInputTextField.snp.left)
            $0.right.equalTo(nameInputTextField.snp.right)
            $0.height.equalTo(50)
        }
    }
}

extension JoinNameViewController: UITextFieldDelegate {
//    @objc private func textFieldEditingChanged(_ textField: UITextField) {
//        guard let name = nameInputTextField.text, !name.isEmpty else {
//            nextButton.backgroundColor = .snaptimeGray
//            nextButton.isEnabled = true
//            return
//        }
//    }
}

extension JoinNameViewController: CustomAlertDelegate {
    func action(identifier: String) {
        guard let navigationController = self.navigationController else { return }
        let viewControllerStack = navigationController.viewControllers
        
        viewControllerStack.forEach {
            if let rootVC = $0 as? JoinEmailViewController {
                self.delegate?.backToSpecificVC(rootVC)
            }
        }
    }
    
    func exit(identifier: String) {
        delegate?.backToRoot()
    }
}
