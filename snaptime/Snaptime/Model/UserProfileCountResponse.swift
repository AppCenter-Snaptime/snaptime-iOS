//
//  UserProfileCountResponse.swift
//  Snaptime
//
//  Created by Bowon Han on 5/13/24.
//

import Foundation

struct UserProfileCountResponse: Decodable {
    let msg: String
    var result: UserProfileCountResDTO
}

struct UserProfileCountResDTO: Decodable {
    var snapCnt: Int
    var followerCnt: Int
    var followingCnt: Int
}
