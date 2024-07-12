//
//  FindAllAlbumsResDto.swift
//  Snaptime
//
//  Created by 이대현 on 5/20/24.
//

import Foundation

struct CommonResponseDtoListFindAllAlbumsResDto: Codable {
    let msg: String
    let result: [FindAllAlbumsResDto]
}

struct FindAllAlbumsResDto: Codable {
    let id: Int
    let name: String
    let photoUrl: String?
}

