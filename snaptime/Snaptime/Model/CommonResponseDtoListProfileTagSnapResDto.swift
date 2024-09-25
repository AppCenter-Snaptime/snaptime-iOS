//
//  CommonResponseDtoListProfileTagSnapResDto.swift
//  Snaptime
//
//  Created by Bowon Han on 7/13/24.
//

import Foundation

struct CommonResponseDtoListProfileTagSnapResDto: Codable {
    let msg: String
    let result: [ProfileTagSnapResDto]
}

struct ProfileTagSnapResDto: Codable {
    let taggedSnapId: Int
    let snapOwnEmail: String
    let taggedSnapUrl: String
}
