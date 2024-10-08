//
//  RecommendCoordinator.swift
//  snaptime
//
//  Created by Bowon Han on 2/2/24.
//

import UIKit

final class NotificationCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinator: [Coordinator] = []
    
    var navigationController: UINavigationController

    func start() {
        presentNotification()
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.navigationBar.tintColor = .black
    }
}

extension NotificationCoordinator: NotificationViewControllerDelegate,
                                   ProfileViewControllerDelegate,
                                   SnapViewControllerDelegate,
                                   TagViewControllerDelegate {
    func presentTag(tagList: [FindTagUserResDto]) {
        let tagVC = TagViewController(tagList: tagList)
        tagVC.delegate = self
        navigationController.pushViewController(tagVC, animated: true)
    }
    
    func presentNotification() {
        let notificationVC = NotificationViewController()
        notificationVC.delegate = self
        navigationController.pushViewController(notificationVC, animated: true)
    }
    
    func presentProfile(target: ProfileTarget, email: String) {
        let profileVC = ProfileViewController(target: target, loginId: email)
        profileVC.delegate = self
        navigationController.pushViewController(profileVC, animated: true)
    }
    
    func presentSnap(snapId: Int, profileType: ProfileTarget) {
        let snapVC = SnapViewController(snapId: snapId, profileType: profileType)
        snapVC.delegate = self
        navigationController.pushViewController(snapVC, animated: true)
    }
    
    func presentSettingProfile() {
        
    }
    
    func presentSnapPreview(albumId: Int) {
        
    }
    
    func presentFollow(target: FollowTarget, email: String) {
        
    }
    
    func presentCommentVC(snap: FindSnapResDto) {
        
    }
    
    func presentEditSnapVC(snap: FindSnapResDto) {
        
    }
    
    func presentMoveAlbumVC(snap: FindSnapResDto) {
        
    }
    
    func backToPrevious() {
        navigationController.popViewController(animated: true)
    }
    
    func backToRoot() {
        navigationController.popToRootViewController(animated: true)
    }
}
