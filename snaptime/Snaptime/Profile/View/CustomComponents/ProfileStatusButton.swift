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
    private var tabButtonAction: UIAction

    private var customNumberToString: String?
    
    init(_ title: String, action: UIAction) {
        self.customTitle = title
        self.tabButtonAction = action
        super.init(frame: .zero)
        self.setupStyles()
        self.addAction(action, for: .touchUpInside)
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
        titleAttr.font = .systemFont(ofSize: 11.0, weight: .light)
        
        var numberAttr = AttributedString.init(customNumberToString ?? "0")
        numberAttr.font = .systemFont(ofSize: 15.0, weight: .regular)
        
        config.attributedTitle = titleAttr
        config.attributedSubtitle = numberAttr
        config.titlePadding = 3
        config.titleAlignment = .center
        
        self.configuration = config
    }
}
