//
//  ChildReplyAddReqDto.swift
//  Snaptime
//
//  Created by Bowon Han on 10/1/24.
//

import Foundation

struct ChildReplyAddReqDto: Codable {
    let replyMessage: String
    let parentReplyId: Int
    let tagEmail: String
}
