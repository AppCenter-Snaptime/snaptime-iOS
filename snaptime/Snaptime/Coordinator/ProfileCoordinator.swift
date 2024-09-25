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
        guard let id = ProfileBasicUserDefaults().email else { return }
        presentProfile(target: .myself,email: id)
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
                              FollowViewControllerDelegate,
                              AddSnapViewControllerDelegate,
                              SnapTagListViewControllerDelegate,
                              SelectAlbumViewControllerDelegate,
                              CancelAccountViewControllerDelegate,
                              TagViewControllerDelegate
{
    func presentCancelAccount() {
        let cancelAccountVC = CancelAccountViewController()
        cancelAccountVC.delegate = self
        navigationController.pushViewController(cancelAccountVC, animated: true)
    }
    
    func backToAddSnapView(tagList: [FriendInfo]) {
        navigationController.popViewController(animated: true)
        guard let addSnapVC = navigationController.topViewController as? AddSnapViewController else { return }
        addSnapVC.addTagList(tagList: tagList
            .map { return FindTagUserResDto(tagUserEmail: $0.foundEmail, tagUserName: $0.foundUserName) })
    }
    
    func presentAddSnap() {
        let addSnapVC = AddSnapViewController()
        addSnapVC.delegate = self
        navigationController.pushViewController(addSnapVC, animated: true)
    }
    
    func presentSelectAlbumVC() {
        let selectAlbumVC = SelectAlbumViewController(selectMode: .albumSelect)
        selectAlbumVC.delegate = self
        navigationController.pushViewController(selectAlbumVC, animated: true)
    }
    
    func presentTag(tagList: [FindTagUserResDto]) {
        let tagVC = TagViewController(tagList: tagList)
        tagVC.delegate = self
        navigationController.pushViewController(tagVC, animated: true)
    }
    
    // albumId를 addSnapVC에 전달
    func backToPrevious(albumId: Int) {
        navigationController.popViewController(animated: true)
        guard let addSnapVC = navigationController.topViewController as? AddSnapViewController else { return }
        Task {
            await addSnapVC.postNewSnap(albumId: albumId)
            await self.navigationController.popViewController(animated: true)
        }
    }
    
    func presentSnapTagList() {
        let snapTagListVC = SnapTagListViewController()
        snapTagListVC.delegate = self
        navigationController.pushViewController(snapTagListVC, animated: true)
    }
    
    
    func presentCommentVC(snap: FindSnapResDto) {
        let commentVC = CommentViewController(snapID: snap.snapId, userName: snap.writerUserName)
        commentVC.delegate = self
        commentVC.modalPresentationStyle = UIModalPresentationStyle.automatic
        navigationController.present(commentVC, animated: true, completion: nil)
    }
    
    func presentEditSnapVC(snap: FindSnapResDto) {
        let addSnapVC = AddSnapViewController()
        addSnapVC.delegate = self
        navigationController.pushViewController(addSnapVC, animated: true)
    }
    
    func presentProfile(target: ProfileTarget, email: String) {
        let myProfileVC = ProfileViewController(target: target, loginId: email)
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
    
    func presentSnap(snapId: Int, profileType: ProfileTarget) {
        let snapVC = SnapViewController(snapId: snapId, profileType: profileType)
        snapVC.delegate = self
        navigationController.pushViewController(snapVC, animated: true)
    }
    
    func presentNotification() {
        let notificationVC = NotificationViewController()
        notificationVC.delegate = self
        notificationVC.navigationItem.backButtonDisplayMode = .generic
        navigationController.pushViewController(notificationVC, animated: true)
    }
    
    func presentFollow(target: FollowTarget, email: String) {
        let followVC = FollowViewController(target: target, loginId: email)
        followVC.delegate = self
        navigationController.pushViewController(followVC, animated: true)
    }
    
    func presentMoveAlbumVC(snap: FindSnapResDto) {
        let selectAlbumVC = SelectAlbumViewController(selectMode: .moveSnap, snap: snap)
        selectAlbumVC.delegate = self
        navigationController.pushViewController(selectAlbumVC, animated: true)
    }
    
    func presentLogin() {
        guard let appCoordinator = parentCoordinator as? AppCoordinator else { return }
        appCoordinator.start()
    }
    
    func popCurrentVC() {
        navigationController.popViewController(animated: true)
    }
    
    func backToPrevious() {
        navigationController.popViewController(animated: true)
    }
    
    func backToRoot() {
        navigationController.popToRootViewController(animated: true)
    }
}
