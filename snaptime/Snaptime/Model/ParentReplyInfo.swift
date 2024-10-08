//
//  ParentReplyInfo.swift
//  Snaptime
//
//  Created by 이대현 on 7/7/24.
//

import Foundation

struct ParentReplyInfo: Codable, Hashable {
    let writerEmail: String
    let writerProfilePhotoURL: String
    let writerUserName: String
    let content: String
    let replyId: Int
    let timeAgo: String
    let childReplyCnt: Int
}
