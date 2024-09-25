//
//  CommonResponseDtoAlarmFindAllResDto.swift
//  Snaptime
//
//  Created by Bowon Han on 9/12/24.
//

import Foundation

struct CommonResponseDtoAlarmFindAllResDto: Codable {
    let msg: String
    let result: AlarmFindAllResDto
}

struct AlarmFindAllResDto: Codable {
    var notReadAlarmInfoResDtos: [AlarmInfoResDto]
    var readAlarmInfoResDtos: [AlarmInfoResDto]
}

struct AlarmInfoResDto: Codable {
    let alarmId: Int
    let snapPhotoURL: String?
    let senderName: String
    let senderProfilePhotoURL: String
    let timeAgo: String
    let previewText: String?
    let alarmType: String
    let snapId: Int?
    let senderEmail: String
    let createdDate: String
}
