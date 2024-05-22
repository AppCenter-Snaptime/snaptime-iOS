//
//  UserProfileCountModel.swift
//  Snaptime
//
//  Created by Bowon Han on 5/13/24.
//

import Foundation

struct UserProfileCountModel: Decodable {
    let msg: String
    var result: Result
    
    struct Result: Decodable {
        var snapCnt: Int
        var followerCnt: Int
        var followingCnt: Int
    }
}
