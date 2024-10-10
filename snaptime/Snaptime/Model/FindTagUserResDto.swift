//
//  FindTagUserResDto.swift
//  Snaptime
//
//  Created by 이대현 on 7/24/24.
//

import Foundation

struct FindTagUserResDto: Codable {
    let tagUserEmail: String
    let tagUserName: String
    let tagUserProfileUrl: String
    let isFollow: Bool
}
