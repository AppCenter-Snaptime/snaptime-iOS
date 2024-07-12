//
//  ProfileCntResDto.swift
//  Snaptime
//
//  Created by Bowon Han on 5/13/24.
//

import Foundation

struct CommonResponseDtoProfileCntResDto: Decodable {
    let msg: String
    var result: ProfileCntResDto
}

struct ProfileCntResDto: Decodable {
    var snapCnt: Int
    var followerCnt: Int
    var followingCnt: Int
}
