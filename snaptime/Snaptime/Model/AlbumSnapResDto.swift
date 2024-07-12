//
//  AlbumSnapResDto.swift
//  Snaptime
//
//  Created by Bowon Han on 7/12/24.
//

import Foundation

struct CommonResponseDtoListAlbumSnapResDto: Codable {
    let msg: String
    var result: [AlbumSnapResDto]
}

struct AlbumSnapResDto: Codable {
    var albumId: Int
    var albumName: String
    var snapUrlList: [String]
}
