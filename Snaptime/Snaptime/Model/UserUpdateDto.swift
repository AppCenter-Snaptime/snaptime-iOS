//
//  UserUpdateDto.swift
//  Snaptime
//
//  Created by Bowon Han on 7/12/24.
//

import Foundation

struct UserUpdateDto: Codable {
    var name: String
    var loginId: String
    var email: String
    var birthDay: String
}
