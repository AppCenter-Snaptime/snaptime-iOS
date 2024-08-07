//
//  UserPagingResDto.swift
//  Snaptime
//
//  Created by Bowon Han on 8/5/24.
//

import Foundation

struct CommonResponseDtoUserPagingResDto: Codable {
    let msg: String
    let result: UserPagingResDto
}

struct UserPagingResDto: Codable {
    let userFindByNameResDtos: [userFindByNameResDto]
    let hasNextPage: Bool
}

struct userFindByNameResDto: Codable {
    let foundLoginId: String
    let profilePhotoURL: String
    let foundUserName: String
}
