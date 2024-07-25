//
//  CommonResponseDtoListFindFriendResDto.swift
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
    let friendInfos: [FriendInfo]
    let hasNextPage: Bool
}

struct FriendInfo: Codable {
    let foundLoginId: String
    let profilePhotoURL: String
    let foundUserName: String
    let friendId: Int
    let isMyFriend: Bool
}
