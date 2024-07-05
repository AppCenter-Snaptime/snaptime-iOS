//
//  UserAlbumModel.swift
//  Snaptime
//
//  Created by Bowon Han on 5/16/24.
//

import Foundation

struct UserAlbumResponse: Codable {
    let msg: String
    var result: [UserAlbumResDTO]
}

struct UserAlbumResDTO: Codable {
    var albumId: Int
    var albumName: String
    var snapUrlList: [String]
}
