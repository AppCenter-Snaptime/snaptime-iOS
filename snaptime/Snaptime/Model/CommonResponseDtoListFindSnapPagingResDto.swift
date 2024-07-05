//
//  CommonResponseDtoListFindSnapPagingResDto.swift
//  Snaptime
//
//  Created by Bowon Han on 5/29/24.
//

import Foundation

struct CommonResponseDtoListFindSnapPagingResDto: Codable {
    let msg: String
    var result: [SnapResDto]
}

