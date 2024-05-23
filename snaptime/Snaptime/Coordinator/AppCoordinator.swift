//
//  AppCoordinator.swift
//  snaptime
//
//  Created by Bowon Han on 2/2/24.
//

import UIKit

protocol Coordinator : AnyObject {
    // 부모 coordinator 지정
    var parentCoordinator: Coordinator? { get set }
    
    // 자식 cooridnator 저장
    var childCoordinator: [Coordinator] { get set }
    var navigationController : UINavigationController { get set }
    
    // coordinator의 시작 지점
    func start()
}

extension Coordinator {
    /// Removing a coordinator inside a children. This call is important to prevent memory leak.
    /// - Parameter coordinator: Coordinator that finished.
    func childDidFinish(_ coordinator : Coordinator){
        // Call this if a coordinator is done.
        for (index, child) in childCoordinator.enumerated() {
            if child === coordinator {
                childCoordinator.remove(at: index)
                break
            }
        }
    }
}


final class AppCoordinator : Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinator: [Coordinator] = []
    
    var navigationController: UINavigationController

    func start() {
//        startAuthCoordinator()
        startTabbarCoordinator() // test
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.navigationBar.tintColor = .black
    }
    
    func startAuthCoordinator() {
        let authCoordinator = AuthCoordinator(navigationController: navigationController)
        childCoordinator.removeAll()
        authCoordinator.parentCoordinator = self
        childCoordinator.append(authCoordinator)
        authCoordinator.start()
    }
    
    func startTabbarCoordinator() {
        let tabBarCoordinator = TabBarCoordinator(navigationController: navigationController)
        childCoordinator.removeAll()
        tabBarCoordinator.parentCoordinator = self
        tabBarCoordinator.start()
    }
}
