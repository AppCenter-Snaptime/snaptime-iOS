//
//  UserResDto.swift
//  Snaptime
//
//  Created by Bowon Han on 6/24/24.
//

import Foundation

struct CommonResponseDtoUserResDto: Codable {
    var msg: String
    var result: UserResDto
}

struct UserResDto: Codable {
    var id: Int
    var name: String
    var loginId: String
    var email: String
    var birthDay: String
}
