//
//  UserReqDto.swift
//  Snaptime
//
//  Created by Bowon Han on 7/23/24.
//

import Foundation

struct UserReqDto: Codable {
    var name: String
    var loginId: String
    var password: String
    var email: String
    var birthDay: String
}
