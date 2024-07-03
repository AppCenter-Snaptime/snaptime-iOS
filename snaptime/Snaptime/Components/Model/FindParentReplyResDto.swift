//
//  FindParentReplyResDto.swift
//  Snaptime
//
//  Created by 이대현 on 7/3/24.
//

import Foundation

struct FindParentReplyResDto: Codable {
    let writerLoginId: String
    let writerProfilePhotoURL: String
    let writerUserName: String
    let content: String
    let replyId: Int
}
