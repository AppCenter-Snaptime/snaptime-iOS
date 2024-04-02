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
    var presentedViewController: UIViewController? = nil
    
    var navigationController: UINavigationController

    func start() {
        presentMainAlbum()
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.navigationBar.tintColor = .black
    }
}

extension HomeCoordinator : MainAlbumViewControllerDelegate,
                            AlbumSnapViewControllerDelegate,
                            QRReaderViewControllerDelegate,
                            AlbumDetailViewControllerDelegate,
                            AddSnapViewControllerDelegate,
                            SnapTagListViewControllerDelegate {
    
    func presentAddSnap() {
        let addSnapVC = AddSnapViewController()
        addSnapVC.delegate = self
        navigationController.pushViewController(addSnapVC, animated: true)
    }
    
    
    func presentAlbumSnap() {
        let albumSnapVC = AlbumSnapViewController()
        albumSnapVC.delegate = self
        navigationController.pushViewController(albumSnapVC, animated: true)
    }
    
    func presentQRReaderView() {
        let qrReaderVC = QRReaderViewController()
        qrReaderVC.delegate = self
        self.presentedViewController = qrReaderVC
        navigationController.present(qrReaderVC, animated: true)
//        navigationController.pushViewController(addAlbumVC, animated: true)
    }
    
    func didFinishAddAlbum() {
        if let vc = presentedViewController as? QRReaderViewController {
            vc.dismiss(animated: true)
            self.presentedViewController = nil
        }
//        let mainAlbumVC = MainAlbumViewController()
//        mainAlbumVC.delegate = self
//        navigationController.viewControllers = [mainAlbumVC]
    }
    
    func presentMainAlbum() {
        let mainAlbumVC = MainAlbumViewController()
        mainAlbumVC.delegate = self
        navigationController.pushViewController(mainAlbumVC, animated: true)
    }
    
    func presentAlbumDetail() {
        let albumDetailVC = AlbumDetailViewController()
        albumDetailVC.delegate = self
        navigationController.pushViewController(albumDetailVC, animated: true)
    }
    
    func presentSnapTagList() {
        let snapTagListVC = SnapTagListViewController()
        snapTagListVC.delegate = self
        navigationController.pushViewController(snapTagListVC, animated: true)
    }
}
