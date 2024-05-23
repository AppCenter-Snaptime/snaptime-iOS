//
//  AlbumSnapResDto.swift
//  Snaptime
//
//  Created by 이대현 on 5/20/24.
//

import Foundation

struct AlbumSnapResDto: Codable {
    let id: Int
    let name: String
    let photoUrl: String?
}

struct AlbumListResponse: Codable {
    let msg: String
    let result: [AlbumSnapResDto]
}
