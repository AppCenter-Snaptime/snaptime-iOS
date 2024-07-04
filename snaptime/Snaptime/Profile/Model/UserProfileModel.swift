//
//  UserProfileModel.swift
//  Snaptime
//
//  Created by Bowon Han on 5/13/24.
//

import Foundation

struct UserProfileResponse: Codable {
    let msg: String
    var result: UserProfileResDTO
}

struct UserProfileResDTO: Codable {
    var userId: Int
    var userName: String
    var profileURL: String
}

