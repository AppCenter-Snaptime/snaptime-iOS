//
//  OAuthButton.swift
//  Snaptime
//
//  Created by Bowon Han on 7/25/24.
//

import UIKit
import SnapKit

final class OAuthButton: UIButton {
    private let buttonImageName: String
    
    init(imageName: String) {
        self.buttonImageName = imageName
        super.init(frame: .zero)
        self.setStyles()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }
    
    private func setConstraints() {
        self.snp.makeConstraints {
            $0.height.width.equalTo(50)
        }
    }
    
    private func setStyles() {
        self.backgroundColor = .snaptimeGray
        self.imageView?.image = UIImage(systemName: buttonImageName)
    }
}
