//
//  HomeCoordinator.swift
//  snaptime
//
//  Created by Bowon Han on 2/2/24.
//

import UIKit

final class HomeCoordinator: Coordinator {
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

extension HomeCoordinator:
    MainAlbumViewControllerDelegate,
    SnapViewControllerDelegate,
    QRReaderViewControllerDelegate,
    SnapPreviewViewControllerDelegate,
    AddSnapViewControllerDelegate,
    SnapTagListViewControllerDelegate,
    CommentViewControllerDelegate,
    SelectAlbumViewControllerDelegate,
    SelectBrandViewControllerDelegate,
    ProfileViewControllerDelegate {
    
    func presentProfile(target: ProfileTarget, loginId: String) {
        let myProfileVC = ProfileViewController(target: target, loginId: loginId)
        myProfileVC.delegate = self
        navigationController.pushViewController(myProfileVC, animated: true)
    }
    
    func presentSettingProfile() {
        
    }
    
    func presentNotification() {
        
    }
    
    func presentFollow(target: FollowTarget, loginId: String) {
        
    }
    
    // ----------------------------
    // MainAlbumViewControllerDelegate
    
    func presentSnapPreview(albumId: Int) {
        let albumDetailVC = SnapPreviewViewController(albumID: albumId)
        albumDetailVC.delegate = self
        navigationController.pushViewController(albumDetailVC, animated: true)
    }
    
    func presentQRReaderView(didSelectedBrand: FourCutBrand) {
        let qrReaderVC = QRReaderViewController(didSelectedBrand: didSelectedBrand)
        qrReaderVC.delegate = self
        self.presentedViewController = qrReaderVC
        navigationController.present(qrReaderVC, animated: true)
    }
    
    func presentSelectBrand() {
        let selectBrandVC = SelectBrandViewController()
        selectBrandVC.delegate = self
        navigationController.pushViewController(selectBrandVC, animated: true)
    }
    
    func presentAddSnap() {
        let addSnapVC = AddSnapViewController()
        addSnapVC.delegate = self
        navigationController.pushViewController(addSnapVC, animated: true)
    }
    
    func presentAlbumDelete() {
        let selectAlbumVC = SelectAlbumViewController(selectMode: .deleteAlbum)
        selectAlbumVC.delegate = self
        navigationController.pushViewController(selectAlbumVC, animated: true)
    }
    
    // ----------------------------
    // SnapViewControllerDelegate
    
    func presentCommentVC(snap: FindSnapResDto) {
        let commentVC = CommentViewController(snapID: snap.snapId, userName: snap.writerUserName)
        commentVC.delegate = self
        commentVC.modalPresentationStyle = UIModalPresentationStyle.automatic
        navigationController.present(commentVC, animated: true, completion: nil)
    }
    
    func presentEditSnapVC(snap: FindSnapResDto) {
        let addSnapVC = AddSnapViewController()
        addSnapVC.delegate = self
        addSnapVC.setEditMode(snap: snap)
        navigationController.pushViewController(addSnapVC, animated: true)
    }
    
    // ----------------------------
    // AddSnapViewControllerDelegate
    
    func presentSnapTagList() {
        let snapTagListVC = SnapTagListViewController()
        snapTagListVC.delegate = self
        navigationController.pushViewController(snapTagListVC, animated: true)
    }
    
    func presentSelectAlbumVC() {
        let selectAlbumVC = SelectAlbumViewController(selectMode: .albumSelect)
        selectAlbumVC.delegate = self
        navigationController.pushViewController(selectAlbumVC, animated: true)
    }
    
    // ----------------------------
    
    func presentSnap(snapId: Int, profileType: ProfileTarget) {
        let snapVC = SnapViewController(snapId: snapId, profileType: profileType)
        snapVC.delegate = self
        navigationController.pushViewController(snapVC, animated: true)
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
    
    func didFinishAddAlbum(qrImageUrl: String) {
        if let vc = presentedViewController as? QRReaderViewController {
            vc.dismiss(animated: true)
            self.presentedViewController = nil
        }
        
        let addSnapVC = AddSnapViewController(qrImageUrl: qrImageUrl)
        addSnapVC.delegate = self
        navigationController.pushViewController(addSnapVC, animated: true)
    }
    
    func presentMainAlbum() {
        let mainAlbumVC = MainAlbumViewController()
        mainAlbumVC.delegate = self
        navigationController.pushViewController(mainAlbumVC, animated: true)
    }
    
    func backToPrevious() {
        navigationController.popViewController(animated: true)
    }
    
    func backToRoot() {
        navigationController.popToRootViewController(animated: true)
    }
    
    func presentMoveAlbumVC(snap: FindSnapResDto) {
        let selectAlbumVC = SelectAlbumViewController(selectMode: .moveSnap, snap: snap)
        selectAlbumVC.delegate = self
        navigationController.pushViewController(selectAlbumVC, animated: true)
    }
    
    func backToAddSnapView(tagList: [FriendInfo]) {
        navigationController.popViewController(animated: true)
        guard let addSnapVC = navigationController.topViewController as? AddSnapViewController else { return }
        addSnapVC.addTagList(tagList:
                                tagList
            .map { return FindTagUserResDto(
                tagUserLoginId: $0.foundLoginId,
                tagUserName: $0.foundUserName
            )}
        )
    }
}
