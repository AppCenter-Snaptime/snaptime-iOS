//
//  FindSnapResDto.swift
//  Snaptime
//
//  Created by Bowon Han on 7/12/24.
//

import Foundation

struct CommonResponseDtoFindSnapResDto: Codable {
    let msg: String
    let result: FindSnapResDto
}

//struct FindSnapResDto: Codable {
//    var snapId: Int
//    var oneLineJournal: String
//    var snapPhotoURL: String
//    var snapCreatedDate: String
//    var snapModifiedDate: String
//    var loginId: String
//    var profilePhotoURL: String
//    var userName: String
//}

/// 수정해야할 Snap Dto
struct FindSnapResDto: Codable {
    var snapId: Int
    var oneLineJournal: String
    var snapPhotoURL: String
    var snapCreatedDate: String
    var snapModifiedDate: String
    var writerLoginId: String
    var profilePhotoURL: String
    var writerUserName: String
    var findTagUsers: [FindTagUserResDto]
    var likeCnt: Int
    var isLikedSnap: Bool
}

struct FindSnapPreviewResDto: Codable {
    var snapId: Int
    var oneLineJournal: String
    var snapPhotoURL: String
    var snapCreatedDate: String
    var snapModifiedDate: String
    var loginId: String
    var profilePhotoURL: String
    var writerUserName: String
    var findTagUsers: [FindTagUserResDto]
    var likeCnt: Int
    var isLikedSnap: Bool
}

struct FindTagUserResDto: Codable {
    var tagUserLoginId: String
    var tagUserName: String
}
