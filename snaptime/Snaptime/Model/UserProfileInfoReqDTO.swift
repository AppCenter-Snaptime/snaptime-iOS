//
//  UserProfileInfoRequest.swift
//  Snaptime
//
//  Created by Bowon Han on 6/29/24.
//

import Foundation

struct UserProfileInfoReqDTO: Codable {
    var name: String
    var loginId: String
    var email: String
    var birthDay: String
}
