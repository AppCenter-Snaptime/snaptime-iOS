//
//  AppDelegate.swift
//  snaptime
//
//  Created by Bowon Han on 1/28/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var isLogin = false
    var checkLoginCompletion: (() -> Void)?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let result = KeyChain.loadTokens(accessKey: TokenType.accessToken.rawValue, refreshKey: TokenType.refreshToken.rawValue)
        
        /// 저장되어있는 토큰이 있는지 확인
        if (result.access != nil) && (result.refresh != nil) {
            print("🍀토큰 가짐🍀")
            /// 토큰이 존재한다면
            checkLogin { [weak self] result in
                self?.isLogin = result
                
                DispatchQueue.main.async {
                   self?.checkLoginCompletion?()
               }
            }
        }
        
        /// 토큰이 없을 때 바로 completion 블록 호출
        else {
            DispatchQueue.main.async {
                self.checkLoginCompletion?()
            }
        }
        
        /// 스플래시 딜레이
        Thread.sleep(forTimeInterval: 2.0)
        return true
    }
    
    /// 저장된 토큰이 유효한지 확인
    func checkLogin(completion: @escaping (Bool) -> Void) {
        APIService.fetchUserInfo.performRequest { result in
            switch result {
            case .success(let result):
                if let result = result as? CommonResponseDtoUserResDto {
                    ProfileBasicUserDefaults().loginId = result.result.loginId
                    completion(true)
                    print("🍀로그인 되어있음🍀")
                }
            case .failure(_):
                completion(false)
                print("⚠️모든 토큰 만료⚠️")
            }
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

