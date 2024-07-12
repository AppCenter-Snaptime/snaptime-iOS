//
//  CommunityCoordinator.swift
//  snaptime
//
//  Created by Bowon Han on 2/2/24.
//

import UIKit

final class CommunityCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinator: [Coordinator] = []
    
    var navigationController: UINavigationController

    func start() {
        presentCommunity()
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.navigationBar.isHidden = true
    }
}

extension CommunityCoordinator:
    CommunityViewControllerDelegate,
    NotificationViewControllerDelegate,
    CommentViewControllerDelegate {
    func presentCommunity() {
        let communityVC = CommunityViewController()
        communityVC.delegate = self
        navigationController.pushViewController(communityVC, animated: true)
    }
    
    func presentNotification() {
        let notificationVC = NotificationViewController()
        notificationVC.delegate = self
        navigationController.pushViewController(notificationVC, animated: true)
    }
    
    func presentCommentVC(snap: SnapResDTO) {
        let commentVC = CommentViewController(snapID: snap.snapId, userName: snap.userName)
        commentVC.delegate = self
        commentVC.modalPresentationStyle = UIModalPresentationStyle.automatic
        navigationController.present(commentVC, animated: true, completion: nil)
    }
}
