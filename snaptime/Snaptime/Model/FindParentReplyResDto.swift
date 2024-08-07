//
//  FindParentReplyResDto.swift
//  Snaptime
//
//  Created by 이대현 on 7/3/24.
//

import Foundation

struct FindParentReplyResDto: Codable {
    let parentReplyInfoResDtos: [ParentReplyInfo]
    let hasNextPage: Bool
}
