//
//  ProfileTabButton.swift
//  Snaptime
//
//  Created by Bowon Han on 2/21/24.
//

import UIKit
import SnapKit

final class ProfileTabListButton : UIButton {
    private let tabTitle : String
    var tabButtonAction : (() -> ())?
    
    init(_ title: String) {
        self.tabTitle = title
        super.init(frame: .zero)
        self.setupStyles()
        self.addTarget(self, action: #selector(tabButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tabButton() {
        self.tabButtonAction?()
    }
    
    private func setupStyles() {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .white
        config.baseForegroundColor = .black

        var titleAttr = AttributedString.init(tabTitle)
        titleAttr.font = .systemFont(ofSize: 15.0, weight: .light)
        
        config.attributedTitle = titleAttr
        
        self.configuration = config
    }
}
