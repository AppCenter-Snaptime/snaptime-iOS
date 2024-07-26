//
//  ProfileCoordinator.swift
//  snaptime
//
//  Created by Bowon Han on 2/2/24.
//

import UIKit

final class ProfileCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinator: [Coordinator] = []
    
    var navigationController: UINavigationController

    func start() {
        presentProfile(target: .myself,loginId: ProfileBasicManager.shared.profile.loginId)
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.navigationBar.tintColor = .black
    }
}

extension ProfileCoordinator: ProfileViewControllerDelegate,
                                EditProfileViewControllerDelegate,
                                SettingProfileViewControllerDelegate,
                               SnapPreviewViewControllerDelegate,
                               SnapViewControllerDelegate,
                              NotificationViewControllerDelegate,
                              CommentViewControllerDelegate,
                            FollowViewControllerDelegate {
    
    func presentCommentVC(snap: FindSnapResDto) {
        let commentVC = CommentViewController(snapID: snap.snapId, userName: snap.writerUserName)
        commentVC.delegate = self
        commentVC.modalPresentationStyle = UIModalPresentationStyle.automatic
        navigationController.present(commentVC, animated: true, completion: nil)
    }
    
    func presentProfile(target: ProfileTarget, loginId: String) {
        let myProfileVC = ProfileViewController(target: target, loginId: loginId)
        myProfileVC.delegate = self
        navigationController.pushViewController(myProfileVC, animated: true)
    }
    
    func presentEditProfile() {
        let editProfileVC = EditProfileViewController()
        editProfileVC.delegate = self
        navigationController.pushViewController(editProfileVC, animated: true)
    }
    
    func presentSettingProfile() {
        let settingProfileVC = SettingProfileViewController()
        settingProfileVC.delegate = self
        navigationController.pushViewController(settingProfileVC, animated: true)
    }
    
    func presentSnapPreview(albumId: Int) {
        let albumDetailVC = SnapPreviewViewController(albumID: albumId)
        albumDetailVC.delegate = self
        navigationController.pushViewController(albumDetailVC, animated: true)
    }
    
    func presentSnap(snapId: Int) {
        let albumSnapVC = SnapViewController(snapId: snapId)
        albumSnapVC.delegate = self
        navigationController.pushViewController(albumSnapVC, animated: true)
    }
    
    func presentNotification() {
        let notificationVC = NotificationViewController()
        notificationVC.delegate = self
        navigationController.pushViewController(notificationVC, animated: true)
    }
    
    func presentFollow(target: FollowTarget, loginId: String) {
        let followVC = FollowViewController(target: target, loginId: loginId)
        followVC.delegate = self
        navigationController.pushViewController(followVC, animated: true)
    }
    
    func presentLogin() {
        guard let appCoordinator = parentCoordinator as? AppCoordinator else { return }
        appCoordinator.start()
    }
    
    func backToPrevious() {
        navigationController.popViewController(animated: true)
    }
    
    func backToRoot() {
        navigationController.popToRootViewController(animated: true)
    }
}
