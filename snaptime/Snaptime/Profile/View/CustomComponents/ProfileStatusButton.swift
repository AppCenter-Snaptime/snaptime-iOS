//
//  ProfileStatusButton.swift
//  Snaptime
//
//  Created by Bowon Han on 2/21/24.
//

import UIKit
import SnapKit

/// 팔로워, 팔로잉, 게시글 수를 나타내기 위한 customButton class
final class ProfileStatusButton: UIButton {
    private let customTitle: String
    private var customNumberToString: String?
    
    init(_ title: String) {
        self.customTitle = title
        super.init(frame: .zero)
        self.setupStyles()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupNumber(number: Int) {
        customNumberToString = String(number)
        self.setupStyles()
    }
  
    private func setupStyles() {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .white
        config.baseForegroundColor = .black

        var titleAttr = AttributedString.init(customTitle)
        titleAttr.font = UIFont(name: SuitFont.regular, size: 12)
        
        var numberAttr = AttributedString.init(customNumberToString ?? "0")
        numberAttr.font = UIFont(name: SuitFont.bold, size: 16)
        
        config.attributedTitle = titleAttr
        config.attributedSubtitle = numberAttr
        config.titlePadding = 3
        config.titleAlignment = .center
        
        self.configuration = config
    }
}
