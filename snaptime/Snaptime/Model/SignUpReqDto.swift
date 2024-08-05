//
//  SignUpReqDto.swift
//  Snaptime
//
//  Created by Bowon Han on 8/5/24.
//

import Foundation

struct SignUpReqDto: Codable {
    var name: String?
    var loginId: String?
    var password: String?
    var email: String?
    var birthDay: String?
}
