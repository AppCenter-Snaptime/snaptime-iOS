//
//  UserFindResDto.swift
//  Snaptime
//
//  Created by Bowon Han on 8/5/24.
//

import Foundation

struct CommonResponseDtoUserFindResDto: Codable {
    let msg: String
    let result: [UserFindResDto]
}

struct UserFindResDto: Codable {
    var userId: String?
    var name: String?
    var loginId: String?
    var email: String?
    var birthDay: String?
}
