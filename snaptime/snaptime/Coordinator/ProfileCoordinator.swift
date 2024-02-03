//
//  ProfileCoordinator.swift
//  snaptime
//
//  Created by Bowon Han on 2/2/24.
//

import UIKit

final class ProfileCoordinator : Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinator: [Coordinator] = []
    
    var navigationController: UINavigationController

    func start() {
        presentMyProfile()
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

extension ProfileCoordinator : MyProfileNavigation {
    func presentMyProfile() {
        let myProfileVC = MyProfileViewController(coordinator: self)
        navigationController.pushViewController(myProfileVC, animated: true)
    }
}
