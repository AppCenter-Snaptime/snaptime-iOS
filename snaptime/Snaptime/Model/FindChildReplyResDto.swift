//
//  FindChildReplyResDto.swift
//  Snaptime
//
//  Created by 이대현 on 7/8/24.
//

import Foundation

struct FindChildReplyResDto: Codable {
    let childReplyInfoResDtos: [ChildReplyInfo]
    let hasNextPage: Bool
}
