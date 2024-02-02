//
//  HomeCoordinator.swift
//  snaptime
//
//  Created by Bowon Han on 2/2/24.
//

import UIKit

final class HomeCoordinator : Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinator: [Coordinator] = []
    
    var navigationController: UINavigationController

    func start() {
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}
