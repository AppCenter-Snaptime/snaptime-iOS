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

struct FindSnapResDto: Codable {
    var snapId: Int
    var oneLineJournal: String
    var snapPhotoURL: String
    var snapCreatedDate: String
    var snapModifiedDate: String
    var loginId: String
    var profilePhotoURL: String
    var userName: String
}
