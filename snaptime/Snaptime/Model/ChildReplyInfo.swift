//
//  ChildReplyInfo.swift
//  Snaptime
//
//  Created by 이대현 on 7/8/24.
//

import Foundation

struct ChildReplyInfo: Codable {
    let writerLoginId: String
    let writerUserName: String
    let writerProfilePhotoURL: String
    let content: String
    let tagUserLoginId: String?
    let tagUserName: String?
    let parentReplyId: Int
    let childReplyId: Int
    let timeAgo: String
}
