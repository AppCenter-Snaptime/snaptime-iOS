//
//  CommonResponseDtoSignInResDto.swift
//  Snaptime
//
//  Created by Bowon Han on 7/22/24.
//

import Foundation

struct CommonResponseDtoSignInResDto: Codable {
    let msg: String
    let result: SignInResDto
}

struct SignInResDto: Codable {
    let testAccessToken: String
    let testRefreshToken: String
}
