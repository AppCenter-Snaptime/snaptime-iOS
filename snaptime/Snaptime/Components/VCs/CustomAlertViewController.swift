//
//  CustomAlertViewController.swift
//  Snaptime
//
//  Created by Bowon Han on 7/14/24.
//

import UIKit
import SnapKit

//protocol CustomAlertDelegate {
//    func action()
//    func exit()
//}

protocol CustomAlertDelegate {
    func action(identifier: String)
    func exit(identifier: String)
}

extension CustomAlertDelegate where Self: UIViewController {
    func show(
        alertText: String,
        cancelButtonText: String,
        confirmButtonText: String,
        identifier: String
    ) {
        let customAlertViewController = CustomAlertViewController(
            alertText: alertText,
            cancelButtonText: cancelButtonText,
            confirmButtonText: confirmButtonText,
            
            identifier: identifier)
        
        customAlertViewController.delegate = self
        
        customAlertViewController.modalPresentationStyle = .overFullScreen
        customAlertViewController.modalTransitionStyle = .crossDissolve
        
        self.present(customAlertViewController, animated: true, completion: nil)
    }
}

final class CustomAlertViewController: UIViewController {
    var delegate: CustomAlertDelegate?

    private var identifier: String
    private var alertText: String
    private var cancelButtonText: String
    private var confirmButtonText: String
    
    init(alertText: String, cancelButtonText: String, confirmButtonText: String, identifier: String) {
        self.alertText = alertText
        self.cancelButtonText = cancelButtonText
        self.confirmButtonText = confirmButtonText
        self.identifier = identifier
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
        
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        titleLabel.text = self.alertText
        confirmButton.setTitle(self.confirmButtonText, for: .normal)
        cancelButton.setTitle(self.cancelButtonText, for: .normal)
        
        setCustomAlertView()
        setupLayouts()
        setupConstraints()
        
        confirmButton.addAction(UIAction { [weak self] _ in
            self?.confirmButtonClick()
        }, for: .touchUpInside)
        
        cancelButton.addAction(UIAction { [weak self] _ in
            self?.cancelButtonClick()
        }, for: .touchUpInside)
    }
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor.black.cgColor.copy(alpha: 0.5)
        
        return view
    }()
    
    private let alertView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(hexCode: "FBFBFB")
        
        return view
    }()
    
    private let titleLabel = UILabel()
    private lazy var confirmButton = UIButton()
    private lazy var cancelButton = UIButton()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 8
        [confirmButton, cancelButton].forEach {
            stackView.addArrangedSubview($0)
        }
        
        return stackView
    }()
    
    private func confirmButtonClick() {
        self.dismiss(animated: true) {
            self.delegate?.action(identifier: self.identifier)
        }
    }
    
    private func cancelButtonClick() {
        self.dismiss(animated: true) {
            self.delegate?.exit(identifier: self.identifier)
        }
    }
    
    private func setCustomAlertView() {
        alertView.layer.cornerRadius = 10
        
        titleLabel.text = alertText
        titleLabel.textColor = UIColor.init(hexCode: "282828")
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 13, weight: .regular)
        
        cancelButton.layer.cornerRadius = 20
        cancelButton.setTitleColor(.snaptimeBlue, for: .normal)
        cancelButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        
        confirmButton.backgroundColor = UIColor.init(hexCode: "D9D9D9")
        confirmButton.layer.cornerRadius = 12
        confirmButton.setTitleColor(UIColor.init(hexCode: "606060"), for: .normal)
        confirmButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
    }
    
    private func setupLayouts() {
        [titleLabel,
         buttonStackView].forEach {
            alertView.addSubview($0)
        }
        
        backgroundView.addSubview(alertView)
        
        view.addSubview(backgroundView)
    }
    
    private func setupConstraints() {
        backgroundView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        alertView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(300)
            $0.leading.equalToSuperview().offset(42)
            $0.trailing.equalToSuperview().offset(-42)
            $0.height.equalTo(172)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.leading.trailing.equalToSuperview().inset(21)
            $0.height.equalTo(20)
        }
        
        [cancelButton, confirmButton].forEach {
            $0.snp.makeConstraints {
                $0.width.equalToSuperview()
            }
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(titleLabel)
            $0.bottom.equalToSuperview().offset(-16)
        }
    }
}
