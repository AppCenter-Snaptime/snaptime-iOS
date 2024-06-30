//
//  Album.swift
//  Snaptime
//
//  Created by 이대현 on 5/1/24.
//

import Foundation

struct Album {
    init(id: Int, name: String, photoURL: String?) {
        self.id = id
        self.name = name
        self.photoURL = photoURL
    }
    
    init(_ dto: AlbumSnapResDto) {
        self.id = dto.id
        self.name = dto.name
        self.photoURL = dto.photoUrl
    }
    
    let id: Int
    let name: String
    let photoURL: String?
}
