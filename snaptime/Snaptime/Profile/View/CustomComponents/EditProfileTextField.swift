//
//  EditProfileTextField.swift
//  Snaptime
//
//  Created by Bowon Han on 3/1/24.
//

import UIKit
import SnapKit

final class EditProfileTextField: UIView {
    private let customDescription: String
    private let isEnabledEditTextField: Bool
    
    init(_ description: String, isEnabledEdit: Bool = true) {
        self.isEnabledEditTextField = isEnabledEdit
        self.customDescription = description
        super.init(frame: .zero)
        self.setupStyles()
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: SuitFont.medium, size: 14)
        label.textColor = .snaptimeBlue
        
        return label
    }()
    
    var editTextField = AuthTextField("")
    
    private func setupStyles() {
        self.descriptionLabel.text = customDescription
        editTextField.delegate = self
    }
    
    private func setupConstraints() {
        [descriptionLabel,
         editTextField].forEach {
            addSubview($0)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.left.equalToSuperview()
        }
        
        editTextField.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(5)
            $0.left.equalTo(descriptionLabel.snp.left)
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}

extension EditProfileTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if isEnabledEditTextField {
            textField.tintColor = .clear
        }
        
        return isEnabledEditTextField
    }
}
