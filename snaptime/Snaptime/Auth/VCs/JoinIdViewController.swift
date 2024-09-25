//
//  File.swift
//  snaptime
//
//  Created by Bowon Han on 2/1/24.
//

//import UIKit
//import SnapKit
//
//protocol JoinIdViewControllerDelegate: AnyObject {
//    func backToPrevious()
//    func backToRoot()
//    func presentLogin()
//    func backToSpecificVC(_ vc: UIViewController)
//}
//
//final class JoinIdViewController: BaseViewController {
//    weak var delegate: JoinIdViewControllerDelegate?
//    
//    private var registrationInfo: SignUpReqDto
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        tabNextButton()
//        textFieldEditing()
//    }
//    
//    init(info: SignUpReqDto) {
//        self.registrationInfo = info
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    // MARK: - UI component Config
//    private let idLabel: UILabel = {
//        let label = UILabel()
//        label.text = "사용하실 아이디를 입력해주세요"
//        label.font = .systemFont(ofSize: 20, weight: .semibold)
//        label.textAlignment = .center
//        
//        return label
//    }()
//    
//    private var idInputTextField = AuthTextField("@snaptime123")
//    private let idConditionalLabel: UILabel = {
//        let label = UILabel()
//        label.text = "소문자 영어와 숫자로 구성해주세요"
//        label.font = .systemFont(ofSize: 10)
//        
//        return label
//    }()
//    
//    private lazy var nextButton = SnapTimeCustomButton("다음", false)
//    
//    // MARK: - button click method
//    private func tabNextButton() {
//        nextButton.addAction(UIAction {[weak self] _ in
//            self?.registrationInfo.loginId = self?.idInputTextField.text
//            guard let info = self?.registrationInfo else { return }
//            print(info)
//
//            self?.postSignUp(info: info)
//        }, for: .touchUpInside)
//    }
//    
//    private func textFieldEditing() {
//        idInputTextField.delegate = self
//        idInputTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
//    }
//    
//    private func postSignUp(info: SignUpReqDto) {
//        APIService.postSignUp.performRequest(with: info, responseType: CommonResDtoVoid.self) { result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(_):
//                    self.delegate?.presentLogin()
//                case .failure(let error):
//                    self.show(
//                        alertText: "회원가입 실패. 다시 시도하시겠습니까?",
//                        cancelButtonText: "아니오",
//                        confirmButtonText: "예",
//                        identifier: "failSignUp"
//                    )
//                    print(error)
//                }
//            }
//        }
//    }
//
//    // MARK: - setup UI
//    override func setupLayouts() {
//        [idLabel,
//         idInputTextField,
//         idConditionalLabel,
//         nextButton].forEach {
//            view.addSubview($0)
//        }
//    }
//    
//    override func setupConstraints() {
//        idLabel.snp.makeConstraints {
//            $0.top.equalTo(view.safeAreaLayoutGuide).offset(84)
//            $0.centerX.equalToSuperview()
//        }
//        
//        idInputTextField.snp.makeConstraints {
//            $0.top.equalTo(idLabel.snp.bottom).offset(106)
//            $0.left.equalTo(view.safeAreaLayoutGuide).offset(48)
//            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-48)
//        }
//        
//        idConditionalLabel.snp.makeConstraints {
//            $0.top.equalTo(idInputTextField.snp.bottom).offset(3)
//            $0.left.equalTo(idInputTextField.snp.left).offset(8)
//        }
//        
//        nextButton.snp.makeConstraints {
//            $0.top.equalTo(idConditionalLabel.snp.bottom).offset(58)
//            $0.left.equalTo(idInputTextField.snp.left)
//            $0.right.equalTo(idInputTextField.snp.right)
//            $0.height.equalTo(50)
//        }
//    }
//}
//
//extension JoinIdViewController: UITextFieldDelegate {
//    @objc private func textFieldEditingChanged(_ textField: UITextField) {
//        if textField.text?.count == 1 {
//            if textField.text?.first == " " {
//                textField.text = ""
//                return
//            }
//        }
//         
//        guard
//            let id = idInputTextField.text, !id.isEmpty
//        else {
//            nextButton.backgroundColor = .snaptimeGray
//            nextButton.isEnabled = false
//            return
//        }
//        nextButton.backgroundColor = .snaptimeBlue
//        nextButton.isEnabled = true
//    }
//}
//
//extension JoinIdViewController: CustomAlertDelegate {
//    func action(identifier: String) {
//        guard let navigationController = self.navigationController else { return }
//        let viewControllerStack = navigationController.viewControllers
//        
//        viewControllerStack.forEach {
//            if let rootVC = $0 as? JoinEmailViewController {
//                self.delegate?.backToSpecificVC(rootVC)
//            }
//        }
//    }
//    
//    func exit(identifier: String) {
//        delegate?.backToRoot()
//    }
//}
