//
//  ProfileBasicUserDefaults.swift
//  Snaptime
//
//  Created by Bowon Han on 5/13/24.
//

import Foundation

/// 로그인 아이디를 저장하는 UserDefaults 클래스
class ProfileBasicUserDefaults {
    private var loginIdKey: String = "LoginIdKey"
    
    var loginId: String? {
        get {
            loadLoginId(key: loginIdKey)
        }
        
        set {
            if let newValue = newValue {
                saveLoginId(id: newValue, key: loginIdKey)
            } else {
                deleteLoginId(key: loginIdKey)
            }
        }
    }
    
    private func saveLoginId(id: String, key: String) {
        let userDefault = UserDefaults.standard
        userDefault.set(id, forKey: key)
    }
    
    private func loadLoginId(key: String) -> String? {
        let userDefaults = UserDefaults.standard
        
        guard let id = userDefaults.string(forKey: key) else {
            print("⚠️userDefault data 찾기 실패⚠️")
            return ""
        }
    
        return id
    }
    
    private func deleteLoginId(key: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: key)
    }
}

