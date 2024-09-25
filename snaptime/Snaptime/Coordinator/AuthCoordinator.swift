//
//  AuthCoordinator.swift
//  snaptime
//
//  Created by Bowon Han  on 2/2/24.
//

import UIKit

final class AuthCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinator: [Coordinator] = []
    
    var navigationController: UINavigationController

    func start() {
        presentLogin() 
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.navigationBar.tintColor = .black
    }
}

// MARK: - coodinator와 연결된 VC의 navigation
extension AuthCoordinator: LoginViewControllerDelegate,
                            JoinEmailViewControllerDelegate,
                            JoinPasswordViewControllerDelegate,
                            JoinNameViewControllerDelegate {
    
    func presentHome() {
        let appCoordinator = parentCoordinator as! AppCoordinator
        appCoordinator.startTabbarCoordinator()
        appCoordinator.childDidFinish(self)
    }
    
    func presentLogin() {
        let loginVC = LoginViewController()
        loginVC.delegate = self
        navigationController.pushViewController(loginVC, animated: true)
    }
    
    func presentJoinEmail() {
        let joinEmailVC = JoinEmailViewController()
        joinEmailVC.delegate = self
        navigationController.pushViewController(joinEmailVC, animated: true)
    }
    
    func presentJoinPassword(info: SignUpReqDto) {
        let joinPasswordVC = JoinPasswordViewController(info: info)
        joinPasswordVC.delegate = self
        navigationController.pushViewController(joinPasswordVC, animated: true)
    }
    
    func presentJoinName(info: SignUpReqDto) {
        let joinNameVC = JoinNameViewController(info: info)
        joinNameVC.delegate = self
        navigationController.pushViewController(joinNameVC, animated: true)
    }
    
//    func presentJoinID(info: SignUpReqDto) {
//        let joinIdVC = JoinIdViewController(info: info)
//        joinIdVC.delegate = self
//        navigationController.pushViewController(joinIdVC, animated: true)
//    }
    
    func backToRoot() {
        navigationController.popToRootViewController(animated: true)
    }
    
    func backToSpecificVC(_ vc: UIViewController) {
        navigationController.popToViewController(vc, animated: true)
    }
    
    func backToPrevious() {
        navigationController.popViewController(animated: true)
    }
}
