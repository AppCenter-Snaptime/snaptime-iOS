//
//  TabBarController.swift
//  snaptime
//
//  Created by Bowon Han on 2/1/24.
//

import UIKit
import SnapKit

class TabBarController : UITabBarController {
//    let homeVC = MainAlbumViewController()
//    let communityVC = CommunityViewController()
//    let myProfileVC = MyProfileViewController()
//    let noneVC = JoinIdViewController()
    
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

//        let homeTabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house"), tag: 0)
//        let communityTabBarItem = UITabBarItem(title: "커뮤니티", image: UIImage(systemName: "magnifyingglass"), tag: 1)
//        let noneTabBarItem = UITabBarItem(title: "미정", image: UIImage(systemName: "hourglass.bottomhalf.filled"), tag: 2)
//        let profileTabBarItem = UITabBarItem(title: "프로필", image: UIImage(systemName: "person.circle"), tag: 3)
//        
//        [homeTabBarItem,
//         communityTabBarItem,
//         noneTabBarItem,
//         profileTabBarItem].forEach{
//            tabBar.items?.append($0)
//        }
//        
//        homeVC.tabBarItem = homeTabBarItem
//        communityVC.tabBarItem = communityTabBarItem
//        noneVC.tabBarItem = noneTabBarItem
//        myProfileVC.tabBarItem = profileTabBarItem
//        
//        setViewControllers([homeVC,communityVC,noneVC,myProfileVC], animated: true)
        
        
    }
}
