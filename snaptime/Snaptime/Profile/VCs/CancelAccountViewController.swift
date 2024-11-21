//
//  CancelAccountViewController.swift
//  Snaptime
//
//  Created by Bowon Han on 9/13/24.
//

import UIKit
import SnapKit

protocol CancelAccountViewControllerDelegate: AnyObject {
    func presentCancelAccount()
    func presentLogin()
}

final class CancelAccountViewController: BaseViewController {
    weak var delegate: CancelAccountViewControllerDelegate?
    
    private var selectedReasonTag: Int? 
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        setButtonAction()
                
        checkButtonState()
                
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    private func checkButtonState() {
        /// 조건: 라디오 버튼 선택, 체크 버튼 선택, 비밀번호 입력
        let isRadioButtonSelected = selectedReasonTag != nil
        let isCheckButtonSelected = checkButton.isSelected
        let isPasswordEntered = !(passwordTextField.text?.isEmpty ?? true)
        
        if isRadioButtonSelected && isCheckButtonSelected && isPasswordEntered {
            /// 활성화 상태
            cancelAccountButton.isEnabled = true
            cancelAccountButton.backgroundColor = .snaptimeBlue
        } else {
            /// 비활성화 상태
            cancelAccountButton.isEnabled = false
            cancelAccountButton.backgroundColor = UIColor.init(hexCode: "d0d0d0") 
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardUp(notification:NSNotification) {
        if let keyboardFrame:NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
           let keyboardRectangle = keyboardFrame.cgRectValue
       
            UIView.animate(
                withDuration: 0.3
                , animations: {
                    self.view.transform = CGAffineTransform(translationX: 0, y: -keyboardRectangle.height)
                }
            )
        }
    }
    
    @objc func keyboardDown() {
        self.view.transform = .identity
    }
    
    private let cancelTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "정말 탈퇴하시겠어요?"
        label.font = UIFont(name: SuitFont.bold, size: 18)
        label.textAlignment = .left
        
        return label
    }()
    
    private let cancelDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "스냅 타임에 기록한 소중한 추억들이 모두 사라져요. 탈퇴 전에 중요한 기록이나 알림이 남아있는지 다시 한 번 확인해주세요."
        label.numberOfLines = 0
        label.textColor = UIColor.init(hexCode: "909090")
        label.font = UIFont(name: SuitFont.medium, size: 14)
        
        return label
    }()
    
    private let cancelReasonLabel: UILabel = {
        let label = UILabel()
        label.text = "탈퇴 사유를 알려주세요."
        label.font = UIFont(name: SuitFont.bold, size: 18)
        label.textAlignment = .left
        
        return label
    }()
    
    private let cancelReasonDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "탈퇴 사유를 알려주신다면 고객님의 피드백을 받아 어플 개선의 자료로 활용하겠습니다."
        label.numberOfLines = 0
        label.textColor = UIColor.init(hexCode: "909090")
        label.font = UIFont(name: SuitFont.medium, size: 14)

        return label
    }()
    
    private lazy var cancelReasonRadioButton = CancelReasonButton(reason: "기록을 삭제하고 싶어요.", tag: 0)
    private lazy var cancelReasonRadioButton2 = CancelReasonButton(reason: "이용이 불편해요.", tag: 1)
    private lazy var cancelReasonRadioButton3 = CancelReasonButton(reason: "사용 빈도가 낮아요.", tag: 2)
    private lazy var cancelReasonRadioButton4 = CancelReasonButton(reason: "앱 오류가 있어요.", tag: 3)
    private lazy var cancelReasonRadioButton5 = CancelReasonButton(reason: "개인정보가 걱정돼요.", tag: 4)
    private lazy var cancelReasonRadioButton6 = CancelReasonButton(reason: "기타", tag: 5)
    
    private let radioButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .leading
        stackView.spacing = 2
        
        return stackView
    }()
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호를 입력해주세요."
        label.font = UIFont(name: SuitFont.bold, size: 18)
        label.textAlignment = .left
        
        return label
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "비밀번호를 입력해주세요."
        textField.borderStyle = .roundedRect
        textField.font = UIFont(name: SuitFont.medium, size: 14)
        textField.isSecureTextEntry = true
        
        return textField
    }()
    
    private lazy var checkButton: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = UIColor.init(hexCode: "d0d0d0")
        config.baseBackgroundColor = .white
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .light)
        let setImage = UIImage(systemName: "checkmark.square", withConfiguration: imageConfig)

        config.image = setImage
        button.configuration = config
        button.isSelected = false
        button.addAction(UIAction{[weak self] _ in
            self?.toggleCheckBox()
        }, for: .touchUpInside)
        
        return button
    }()
    
    private let checkDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "위 내용을 모두 확인했으며, 회원 탈퇴를 진행합니다."
        label.font = UIFont(name: SuitFont.medium, size: 14)
        
        return label
    }()
    
    private lazy var cancelAccountButton = SnapTimeCustomButton("탈퇴하기")
    
    private func toggleCheckBox() {
        checkButton.isSelected.toggle()
        
        if checkButton.isSelected {
            checkButton.configuration?.image = UIImage(systemName: "checkmark.square.fill")
        } else {
            checkButton.configuration?.image = UIImage(systemName: "checkmark.square")
        }
        
        checkButtonState() // 상태 확인
    }
    
    private func setButtonAction() {
        [cancelReasonRadioButton,
         cancelReasonRadioButton2,
         cancelReasonRadioButton3,
         cancelReasonRadioButton4,
         cancelReasonRadioButton5,
         cancelReasonRadioButton6].forEach {
            $0.addTarget(self, action: #selector(self.radioButton(_ :)), for: .touchUpInside)
        }
        
        cancelAccountButton.addAction(UIAction {[weak self] _ in
            self?.show(
                alertText: "탈퇴 하시겠습니까?",
                cancelButtonText: "취소하기",
                confirmButtonText: "네",
                identifier: "deleteUser"
            )
        }, for: .touchUpInside)
    }

    @objc private func radioButton(_ sender: UIButton) {
        selectedReasonTag = sender.tag // 선택된 라디오 버튼 태그 저장

        [cancelReasonRadioButton,
         cancelReasonRadioButton2,
         cancelReasonRadioButton3,
         cancelReasonRadioButton4,
         cancelReasonRadioButton5,
         cancelReasonRadioButton6].forEach {
            if $0.tag == sender.tag {
                let imageConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .thin)
                let setImage = UIImage(
                    systemName: "checkmark.circle.fill",
                    withConfiguration: imageConfig
                )?.withTintColor(.snaptimeBlue, renderingMode: .alwaysOriginal)
                
                $0.configuration?.image = setImage
                
            } else {
                let imageConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .thin)
                let setImage = UIImage(
                    systemName: "circle",
                    withConfiguration: imageConfig
                )?.withTintColor(UIColor.init(hexCode: "d0d0d0"), renderingMode: .alwaysOriginal)
                
                $0.configuration?.image = setImage
            }
        }
        
        checkButtonState() // 상태 확인
    }
    
    @objc private func textFieldDidChange() {
           checkButtonState() // 텍스트 필드 입력 상태 확인
       }
    
    private func deleteUser(password: String) {
        APIService.deleteUser(password: password).performRequest(
            responseType: CommonResDtoVoid.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    let checkTokenDeleted = KeyChain.deleteTokens(accessKey: TokenType.accessToken.rawValue, refreshKey: TokenType.refreshToken.rawValue)
                    
                    ProfileBasicUserDefaults().email = nil
                    
                    if checkTokenDeleted.access && checkTokenDeleted.refresh {
                        self.delegate?.presentLogin()
                    }
                case .failure(let failure):
                    let errorMessage = failure.localizedDescription
                                            
                    self.show(
                        alertText: errorMessage,
                        cancelButtonText: "yes",
                        confirmButtonText: "네",
                        identifier: "failDeleteUser"
                    )
                }
            }
        }
    }
    
    override func setupLayouts() {
        super.setupLayouts()
        
        [cancelReasonRadioButton,
         cancelReasonRadioButton2,
         cancelReasonRadioButton3,
         cancelReasonRadioButton4,
         cancelReasonRadioButton5,
         cancelReasonRadioButton6].forEach {
            radioButtonStackView.addArrangedSubview($0)
        }
        
        [cancelTitleLabel,
         cancelDescriptionLabel,
         cancelReasonLabel,
         cancelReasonDescriptionLabel,
        radioButtonStackView,
         passwordLabel,
         passwordTextField,
         checkButton,
         checkDescriptionLabel,
        cancelAccountButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        cancelTitleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
        cancelDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(cancelTitleLabel.snp.bottom).offset(12)
            $0.left.equalTo(cancelTitleLabel.snp.left)
            $0.right.equalTo(cancelTitleLabel.snp.right)
        }
        
        cancelReasonLabel.snp.makeConstraints {
            $0.top.equalTo(cancelDescriptionLabel.snp.bottom).offset(40)
            $0.left.equalTo(cancelDescriptionLabel.snp.left)
            $0.right.equalTo(cancelDescriptionLabel.snp.right)
        }
        
        cancelReasonDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(cancelReasonLabel.snp.bottom).offset(12)
            $0.left.equalTo(cancelReasonLabel.snp.left)
            $0.right.equalTo(cancelReasonLabel.snp.right)
        }
        
        radioButtonStackView.snp.makeConstraints {
            $0.top.equalTo(cancelReasonDescriptionLabel.snp.bottom).offset(16)
            $0.left.equalTo(cancelReasonDescriptionLabel.snp.left).offset(-15)
            $0.right.equalTo(cancelReasonDescriptionLabel.snp.right)
        }
        
        passwordLabel.snp.makeConstraints {
            $0.top.equalTo(radioButtonStackView.snp.bottom).offset(35)
            $0.left.equalTo(cancelReasonDescriptionLabel.snp.left)
            $0.right.equalTo(cancelReasonDescriptionLabel.snp.right)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(passwordLabel.snp.bottom).offset(12)
            $0.left.equalTo(passwordLabel.snp.left)
            $0.right.equalTo(passwordLabel.snp.right)
            $0.height.equalTo(49)
        }
        
        checkButton.snp.makeConstraints {
            $0.bottom.equalTo(cancelAccountButton.snp.top).offset(-10)
            $0.left.equalTo(cancelAccountButton.snp.left).offset(8)
            $0.height.width.equalTo(20)
        }
        
        checkDescriptionLabel.snp.makeConstraints {
            $0.left.equalTo(checkButton.snp.right).offset(12)
            $0.right.equalTo(cancelAccountButton.snp.right)
            $0.centerY.equalTo(checkButton.snp.centerY)
        }
        
        cancelAccountButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-15)
            $0.left.right.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(52)
        }
    }
}

extension CancelAccountViewController: CustomAlertDelegate {
    func exit(identifier: String) {}
    
    func action(identifier: String) {
        switch identifier {
        case "deleteUser":
            guard let password = passwordTextField.text else { return }
            deleteUser(password: password)
            
        case "failDeleteUser":
            break
        default:
            print("none")
        }
    }
}
