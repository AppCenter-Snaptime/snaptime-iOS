//
//  CommonResponseDtoListFindSnapPagingResDto.swift
//  Snaptime
//
//  Created by Bowon Han on 5/29/24.
//

import Foundation

struct CommonResponseDtoListFindSnapPagingResDto: Codable {
    let msg: String
    var result: FindSnapPagingResDto
}

struct FindSnapPagingResDto: Codable {
    let snapPagingInfoList: [FindSnapResDto]
    let hasNextPage: Bool
}

//struct SnapPagingInfo: Codable {
//    var snapId: Int
//    var oneLineJournal: String
//    var snapPhotoURL: String
//    var snapCreatedDate: String
//    var snapModifiedDate: String
//    var writerLoginId: String
//    var profilePhotoURL: String
//    var writerUserName: String
//    var findTagUserList: [FindTagUserResDto]
//    var likeCnt: Int
//    var isLikedSnap: Bool
//}
//
//struct FindTagUserResDto: Codable {
//    var tagUserLoginId: String
//    var userName: String
//}
