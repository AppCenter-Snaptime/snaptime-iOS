//
//  UserProfileCountManager.swift
//  Snaptime
//
//  Created by Bowon Han on 5/13/24.
//

import Foundation

class UserProfileCountManager {
    var profileCount = UserProfileCountModel(msg: "", result: UserProfileCountModel.Result(snapCnt: 0, followerCnt: 0, followingCnt: 0))
    
    static let shared = UserProfileCountManager()
    
    private init() {}
}
