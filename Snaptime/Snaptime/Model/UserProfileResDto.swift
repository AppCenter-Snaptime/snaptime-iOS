//
//  UserProfileResDTO.swift
//  Snaptime
//
//  Created by Bowon Han on 5/13/24.
//

import Foundation

struct CommonResponseDtoUserProfileResDto: Codable {
    let msg: String
    var result: UserProfileResDto
}

struct UserProfileResDto: Codable {
    var userId: Int
    var userName: String
    var profileURL: String
}

