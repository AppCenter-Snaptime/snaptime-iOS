//
//  CommunityCoordinator.swift
//  snaptime
//
//  Created by Bowon Han on 2/2/24.
//

import UIKit

final class CommunityCoordinator: Coordinator, SelectAlbumViewControllerDelegate {
    var parentCoordinator: Coordinator?
    var childCoordinator: [Coordinator] = []
    
    var navigationController: UINavigationController

    func start() {
        presentCommunity()
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.navigationBar.isHidden = true
        self.navigationController.navigationBar.tintColor = .black
    }
}

extension CommunityCoordinator:
    CommunityViewControllerDelegate,
    NotificationViewControllerDelegate,
    CommentViewControllerDelegate,
    SearchViewControllerDelegate,
    ProfileViewControllerDelegate,
    FollowViewControllerDelegate,
    SnapViewControllerDelegate,
    SnapPreviewViewControllerDelegate,
    EditProfileViewControllerDelegate,
    SettingProfileViewControllerDelegate,
    AddSnapViewControllerDelegate,
    SnapTagListViewControllerDelegate {
    
    func backToAddSnapView(tagList: [FriendInfo]) {
        navigationController.popViewController(animated: true)
        guard let addSnapVC = navigationController.topViewController as? AddSnapViewController else { return }
        addSnapVC.addTagList(tagList: tagList
            .map { return FindTagUserResDto(tagUserLoginId: $0.foundLoginId, tagUserName: $0.foundUserName) })
    }
    
    func presentAddSnap() {
        let addSnapVC = AddSnapViewController()
        addSnapVC.delegate = self
        navigationController.pushViewController(addSnapVC, animated: true)
    }

    func presentSnapTagList() {
        let snapTagListVC = SnapTagListViewController()
        snapTagListVC.delegate = self
        navigationController.pushViewController(snapTagListVC, animated: true)
    }
    
    func presentEditSnapVC(snap: FindSnapResDto) {
        let addSnapVC = AddSnapViewController()
        addSnapVC.delegate = self
        navigationController.pushViewController(addSnapVC, animated: true)
    }
    
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
    
    func backToPrevious(albumId: Int) {
        navigationController.popViewController(animated: true)
    }
    
    func presentSelectAlbumVC() {
        let selectAlbumVC = SelectAlbumViewController(selectMode: .albumSelect)
        selectAlbumVC.delegate = self
        navigationController.pushViewController(selectAlbumVC, animated: true)
    }

    func presentSnap(snapId: Int, profileType: ProfileTarget) {
        let albumSnapVC = SnapViewController(snapId: snapId, profileType: profileType)
        albumSnapVC.delegate = self
        navigationController.pushViewController(albumSnapVC, animated: true)
    }
    
    func presentSnapPreview(albumId: Int) {
        let albumDetailVC = SnapPreviewViewController(albumID: albumId)
        albumDetailVC.delegate = self
        navigationController.pushViewController(albumDetailVC, animated: true)
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
    
    func presentFollow(target: FollowTarget, loginId: String) {
        let followVC = FollowViewController(target: target, loginId: loginId)
        followVC.delegate = self
        navigationController.pushViewController(followVC, animated: true)
    }
    
    func presentMoveAlbumVC(snap: FindSnapResDto) {
        let selectAlbumVC = SelectAlbumViewController(selectMode: .moveSnap, snap: snap)
        selectAlbumVC.delegate = self
        navigationController.pushViewController(selectAlbumVC, animated: true)
    }
    
    func backToRoot() {
        navigationController.popToRootViewController(animated: true)
    }
    
    func presentLogin() {
        guard let appCoordinator = parentCoordinator as? AppCoordinator else { return }
        appCoordinator.start()
    }
}
