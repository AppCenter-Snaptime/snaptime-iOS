//
//  FindSnapResDto.swift
//  Snaptime
//
//  Created by 이대현 on 5/27/24.
//

import Foundation

struct CommonResponseDtoFindAlbumResDto: Codable {
    let msg: String
    let result: FindAlbumResDto
}

struct FindAlbumResDto: Codable {
    let id: Int
    let name: String
    let snap: [FindSnapResDto]
}
