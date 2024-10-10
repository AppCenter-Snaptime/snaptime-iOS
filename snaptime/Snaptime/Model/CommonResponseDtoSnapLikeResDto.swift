//
//  CommonResponseDtoSnapLikeResDto.swift
//  Snaptime
//
//  Created by Bowon Han on 10/10/24.
//

import Foundation

struct CommonResponseDtoSnapLikeResDto: Codable {
    let msg: String
    let result: SnapLikeResDto
}

struct SnapLikeResDto: Codable {
    let message: String
    let likeCnt: Int
}
