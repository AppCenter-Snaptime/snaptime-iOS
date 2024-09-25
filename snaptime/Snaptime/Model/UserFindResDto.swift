//
//  UserFindResDto.swift
//  Snaptime
//
//  Created by Bowon Han on 8/5/24.
//

import Foundation

struct CommonResponseDtoUserFindResDto: Codable {
    let msg: String
    let result: UserFindResDto
}

struct UserFindResDto: Codable {
    var userId: Int
    var name: String
    var email: String
    var nickName: String
}
