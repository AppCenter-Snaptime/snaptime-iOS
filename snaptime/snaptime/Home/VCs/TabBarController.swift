//
//  TabBarController.swift
//  snaptime
//
//  Created by Bowon Han on 2/1/24.
//

import UIKit
import SnapKit

class TabBarController : UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        configTabBar()
        self.tabBar.tintColor = .red
        self.tabBar.backgroundColor = .white
    }
    
    private var buttonStackView = ButtonStackView()

    private func configTabBar(){
        
        tabBar.addSubview(buttonStackView)
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(3)
            $0.bottom.equalToSuperview().offset(-30)
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-15)
        }
    }
}
