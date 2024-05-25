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
        presentMyProfile()
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.isNavigationBarHidden = true
    }
}

extension ProfileCoordinator: MyProfileViewControllerDelegate,
                                EditProfileNavigation,
                                SettingProfileNavigation,
                               AlbumDetailViewControllerDelegate,
                               AlbumSnapViewControllerDelegate {
    func presentMyProfile() {
        let myProfileVC = MyProfileViewController()
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
    
    func presentAlbumDetail() {
        let albumDetailVC = AlbumDetailViewController()
        albumDetailVC.delegate = self
        navigationController.pushViewController(albumDetailVC, animated: true)
    }
    
    func presentAlbumSnap() {
        let albumSnapVC = AlbumSnapViewController()
        albumSnapVC.delegate = self
        navigationController.pushViewController(albumSnapVC, animated: true)
    }
    
    func presentCommentView() {
        
    }
}
