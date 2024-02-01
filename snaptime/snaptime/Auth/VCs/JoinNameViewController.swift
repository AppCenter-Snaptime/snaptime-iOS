//
//  JoinNameViewController.swift
//  snaptime
//
//  Created by Bowon Han on 2/1/24.
//

import UIKit
import SnapKit

final class JoinNameViewController : BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private let nameLabel : UILabel = {
        let label = UILabel()
        label.text = "이름과 생년월일을 입력해주세요"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        
        return label
    }()
    
    private var nameInputTextField = AuthTextField("이름")

    private var birthDateInputTextField = AuthTextField("생년월일 입력")
    private let birthDateConditionalLabel : UILabel = {
        let label = UILabel()
        label.text = "생년월일 양식이 잘못되었습니다"
        label.font = .systemFont(ofSize: 10)
        label.textColor = .red
        
        return label
    }()

    private lazy var nextButton = AuthButton("다음")
    
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
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(130)
            $0.centerX.equalToSuperview()
        }
        
        nameInputTextField.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(110)
            $0.centerX.equalToSuperview()
        }
                
        birthDateInputTextField.snp.makeConstraints {
            $0.top.equalTo(nameInputTextField.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
        }
        
        birthDateConditionalLabel.snp.makeConstraints {
            $0.top.equalTo(birthDateInputTextField.snp.bottom).offset(3)
            $0.leading.equalTo(birthDateInputTextField.snp.leading)
        }
        
        nextButton.snp.makeConstraints {
            $0.top.equalTo(birthDateInputTextField.snp.bottom).offset(70)
            $0.centerX.equalToSuperview()
        }
    }

}
