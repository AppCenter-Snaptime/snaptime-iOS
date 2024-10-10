//
//  ProfileBasicUserDefaults.swift
//  Snaptime
//
//  Created by Bowon Han on 5/13/24.
//

import Foundation

/// 로그인 아이디를 저장하는 UserDefaults 클래스
class ProfileBasicUserDefaults {
    private var emailKey: String = "LoginIdKey"
    
    var email: String? {
        get {
            loadEmail(key: emailKey)
        }
        
        set {
            if let newValue = newValue {
                saveEmail(email: newValue, key: emailKey)
            } else {
                deleteEmail(key: emailKey)
            }
        }
    }
    
    private func saveEmail(email: String, key: String) {
        let userDefault = UserDefaults.standard
        userDefault.set(email, forKey: key)
    }
    
    private func loadEmail(key: String) -> String? {
        let userDefaults = UserDefaults.standard
        
        guard let email = userDefaults.string(forKey: key) else {
            print("⚠️userDefault data 찾기 실패⚠️")
            return ""
        }
    
        return email
    }
    
    private func deleteEmail(key: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: key)
    }
}

