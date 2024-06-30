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
    
    init(_ description: String) {
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
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .snaptimeBlue
        
        return label
    }()
    
    let editTextField = AuthTextField("")
    
    private func setupStyles() {
        self.descriptionLabel.text = customDescription
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
            $0.width.equalTo(324)
            $0.bottom.equalToSuperview()
        }
    }
}
