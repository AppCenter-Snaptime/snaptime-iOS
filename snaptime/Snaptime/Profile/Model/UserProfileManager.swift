//
//  UserProfileManager.swift
//  Snaptime
//
//  Created by Bowon Han on 5/13/24.
//

import Foundation

class UserProfileManager {
    var profile = UserProfileResponse(msg: "", result: UserProfileResDTO(userId: 0, userName: "", profileURL: ""))
    
    static let shared = UserProfileManager()
    
    private init() {}
}
