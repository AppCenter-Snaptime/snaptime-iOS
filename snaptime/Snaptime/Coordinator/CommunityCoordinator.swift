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
    CommentViewControllerDelegate,
    SearchViewControllerDelegate,
    ProfileViewControllerDelegate {
    
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
    
    func presentCommentVC(snap: FindSnapResDto) {
        let commentVC = CommentViewController(snapID: snap.snapId, userName: snap.writerUserName)
        commentVC.delegate = self
        commentVC.modalPresentationStyle = UIModalPresentationStyle.automatic
        navigationController.present(commentVC, animated: true, completion: nil)
    }
    
    func presentSearch() {
        let searchVC = SearchViewController()
        searchVC.delegate = self
        navigationController.pushViewController(searchVC, animated: true)
    }
    
    func presentProfile(target: ProfileTarget, loginId: String) {
        let myProfileVC = ProfileViewController(target: target, loginId: loginId)
        myProfileVC.delegate = self
        navigationController.pushViewController(myProfileVC, animated: true)
    }
    
    func backToPrevious() {
        navigationController.popViewController(animated: true)
    }
    
    func presentSettingProfile() {}
    
    func presentSnapPreview(albumId: Int) {}
    
    func presentFollow(target: FollowTarget, loginId: String) {}
    
    func presentSnap(snapId: Int) {}
}
