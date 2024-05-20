//
//  Album.swift
//  Snaptime
//
//  Created by 이대현 on 5/1/24.
//

import Foundation

struct Album {
    init(name: String, photoURL: String?) {
        self.name = name
        self.photoURL = photoURL
    }
    
    init(_ dto: AlbumSnapResDto) {
        self.name = dto.name
        self.photoURL = dto.photoUrl
    }
    
    let name: String
    let photoURL: String?
}
