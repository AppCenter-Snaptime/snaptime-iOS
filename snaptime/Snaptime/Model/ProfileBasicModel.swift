//
//  ProfileBasicModel.swift
//  Snaptime
//
//  Created by Bowon Han on 5/13/24.
//

import Foundation

struct ProfileBasicModel: Codable {
    var loginId: String
}

//extension ProfileBasicModel {
//    static let profile = ProfileBasicModel(loginId: "bowon0000")
//}

// 일단 싱글톤 객체에 담아놓음
class ProfileBasicManager {
    var profile = ProfileBasicModel(loginId: "")
    
    static let shared = ProfileBasicManager()
    
    private init() {}
}
