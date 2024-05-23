//
//  UserAlbumManager.swift
//  Snaptime
//
//  Created by Bowon Han on 5/16/24.
//

import Foundation

class UserAlbumManager {
    var userAlbumList = UserAlbumModel(msg: "", result: [])
    
    static let shared = UserAlbumManager()
    
    private init() {}
}
