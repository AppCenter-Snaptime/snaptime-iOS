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
        presentMainAlbum()
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

extension HomeCoordinator : MainAlbumNavigation, DetailAlbumNavigation {
    func presentMainAlbum() {
        let mainAlbumVC = MainAlbumViewController(coordinator: self)
        navigationController.pushViewController(mainAlbumVC, animated: true)
    }
    
    func presentDetailAlbum() {
        let detailAlbumVC = DetailAlbumViewController(coordinator: self)
        navigationController.pushViewController(detailAlbumVC, animated: true)
    }
}
