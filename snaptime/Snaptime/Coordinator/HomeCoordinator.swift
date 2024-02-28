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

extension HomeCoordinator : MainAlbumViewControllerDelegate,
                            DetailAlbumNavigation,
                            AddAlbumViewControllerDelegate {
    func presentDetailView() {
        let detailAlbumVC = DetailAlbumViewController(coordinator: self)
        navigationController.pushViewController(detailAlbumVC, animated: true)
    }
    
    func presentAddAlbumView() {
        let addAlbumVC = AddAlbumViewController()
        addAlbumVC.delegate = self
        navigationController.present(addAlbumVC, animated: true)
//        navigationController.pushViewController(addAlbumVC, animated: true)
    }
    
    func didFinishAddAlbum() {
        let mainAlbumVC = MainAlbumViewController()
        mainAlbumVC.delegate = self
        navigationController.viewControllers = [mainAlbumVC]
    }
    
    func presentMainAlbum() {
        let mainAlbumVC = MainAlbumViewController()
        mainAlbumVC.delegate = self
        navigationController.pushViewController(mainAlbumVC, animated: true)
    }
}
