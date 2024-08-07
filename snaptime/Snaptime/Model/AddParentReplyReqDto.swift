//
//  AddParentReplyReqDto.swift
//  Snaptime
//
//  Created by 이대현 on 7/7/24.
//

import Foundation

struct AddParentReplyReqDto: Codable {
    let replyMessage: String
    let snapId: Int
}
