//
//  CommonResponseDto.swift
//  Snaptime
//
//  Created by Bowon Han on 8/12/24.
//

import Foundation

struct CommonResponseDtoModifyUserInfoResDto: Codable {
    let msg: String
    let result: ModifyUserInfoResDto
}

struct ModifyUserInfoResDto: Codable {
    let profilePhotoId: Int
    let profilePhotoName: String
    let profilePhotoPath: String
}
