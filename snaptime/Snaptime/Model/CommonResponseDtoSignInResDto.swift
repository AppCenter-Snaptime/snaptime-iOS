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
    let accessToken: String
    let refreshToken: String
}

// 토큰 테스트 DTO
struct TestCommonResponseDtoSignInResDto: Codable {
    let msg: String
    let result: TestSignInResDto
}

struct TestSignInResDto: Codable {
    let testAccessToken: String
    let testRefreshToken: String
}


