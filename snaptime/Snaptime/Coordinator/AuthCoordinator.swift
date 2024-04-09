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

    // AuthCoordinator 가 시작될 때 호출되는 메서드
    func start() {
        presentLogin() 
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

// MARK: - coodinator와 연결된 VC의 navigation
extension AuthCoordinator: LoginViewControllerDelegate,
                            JoinEmailViewControllerDelegate,
                            JoinIdViewControllerDelegate,
                            JoinPasswordViewControllerDelegate,
                            JoinNameViewControllerDelegate {
    
    // tabBarCoordinator 시작 지점
    func presentHome() {
        let appCoordinator = parentCoordinator as! AppCoordinator
        appCoordinator.startTabbarCoordinator()
        appCoordinator.childDidFinish(self)
    }
    
    // 나타날 화면 구성
    // login 화면
    func presentLogin() {
        let loginVC = LoginViewController()
        loginVC.delegate = self
        navigationController.pushViewController(loginVC, animated: true)
    }
    
    // join 이메일
    func presentJoinEmail() {
        let joinEmailVC = JoinEmailViewController()
        joinEmailVC.delegate = self
        navigationController.pushViewController(joinEmailVC, animated: true)
    }
    
    // join 비밀번호
    func presentJoinPassword() {
        let joinPasswordVC = JoinPasswordViewController()
        joinPasswordVC.delegate = self
        navigationController.pushViewController(joinPasswordVC, animated: true)
    }
    
    // join 이름
    func presentJoinName() {
        let joinNameVC = JoinNameViewController()
        joinNameVC.delegate = self
        navigationController.pushViewController(joinNameVC, animated: true)
    }
    
    // join 아이디
    func presentJoinID() {
        let joinIdVC = JoinIdViewController()
        joinIdVC.delegate = self
        navigationController.pushViewController(joinIdVC, animated: true)
    }
    
    // 회원가입을 마치고 로그인 화면으로 돌아가는 메서드
    func backToRoot() {
        navigationController.popToRootViewController(animated: true)
    }
    
    // 이전 화면으로 돌아가는 메서드
    func backToPrevious() {
        navigationController.popViewController(animated: true)
    }
}
