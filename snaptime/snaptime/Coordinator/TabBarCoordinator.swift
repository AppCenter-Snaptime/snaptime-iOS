//
//  TabBarCoordinator.swift
//  snaptime
//
//  Created by Bowon Han on 2/2/24.
//

import UIKit

final class TabBarCoordinator : Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinator: [Coordinator] = []
    
    var navigationController: UINavigationController

    func start() {
        goToHomeTabbar()
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.isNavigationBarHidden = true
    }
    
    func goToHomeTabbar() {
        let tabbarController = TabBarController()
        
        // home
        let homeNavigationController = UINavigationController()
        let homeCoordinator = HomeCoordinator(navigationController: homeNavigationController)
        
        homeCoordinator.parentCoordinator = parentCoordinator
        
        // community
        let communityNavigationController = UINavigationController()
        let communityCoordinator = CommunityCoordinator(navigationController: communityNavigationController)
        
        communityCoordinator.parentCoordinator = parentCoordinator
        
        // none
        let noneNavigationController = UINavigationController()
        let noneCoordinator = NoneCoordinator(navigationController: noneNavigationController)
        
        noneCoordinator.parentCoordinator = parentCoordinator
        
        //profile
        let profileNavigationController = UINavigationController()
        let profileCoordinator = ProfileCoordinator(navigationController: profileNavigationController)
        
        profileCoordinator.parentCoordinator = parentCoordinator
         
        // config TabBar
        tabbarController.viewControllers = [homeNavigationController,
                                            communityNavigationController,
                                            noneNavigationController,
                                            profileNavigationController]
        
        navigationController.pushViewController(tabbarController, animated: true)
        
        // 자식 coordinator로 tabBar에 지정된 각각의 coordinator 저장
        parentCoordinator?.childCoordinator.append(homeCoordinator)
        parentCoordinator?.childCoordinator.append(communityCoordinator)
        parentCoordinator?.childCoordinator.append(noneCoordinator)
        parentCoordinator?.childCoordinator.append(profileCoordinator)
        
        homeCoordinator.start()
        communityCoordinator.start()
        noneCoordinator.start()
        profileCoordinator.start()
    }
}
