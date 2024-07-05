//
//  SnapResDTO.swift
//  Snaptime
//
//  Created by Bowon Han on 6/16/24.
//

import Foundation

struct CommonResponseDtoFindSnapResDto: Codable {
    let msg: String
    let result: SnapResDto
}

struct SnapResDto: Codable {
    var snapId: Int
    var oneLineJournal: String
    var snapPhotoURL: String
    var snapCreatedDate: String
    var snapModifiedDate: String
    var loginId: String
    var profilePhotoURL: String
    var userName: String
}