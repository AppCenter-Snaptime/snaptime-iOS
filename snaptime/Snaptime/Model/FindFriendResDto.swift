//
//  FindFriendResDto.swift
//  Snaptime
//
//  Created by Bowon Han on 7/5/24.
//

import Foundation

struct CommonResponseDtoListFindFriendResDto: Codable {
    let msg: String
    let result: FindFriendResDto
}

struct FindFriendResDto: Codable {
    let friendInfoList: [FriendInfo]
    let hasNextPage: Bool
}

struct FriendInfo: Codable {
    let loginId: String
    let profilePhotoURL: String
    let userName: String
    let friendShipId: Int
}
