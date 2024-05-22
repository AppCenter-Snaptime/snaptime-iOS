//
//  UserAlbumModel.swift
//  Snaptime
//
//  Created by Bowon Han on 5/16/24.
//

import Foundation

struct UserAlbumModel: Codable {
    let msg: String
    var result: [Result]
    
    struct Result: Codable {
        var albumId: Int
        var albumName: String
        var snapUrlList: [String]
    }
}
