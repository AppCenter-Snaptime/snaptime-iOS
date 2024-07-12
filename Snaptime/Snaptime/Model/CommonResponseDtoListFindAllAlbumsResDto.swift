//
//  CommonResponseDtoListFindAllAlbumsResDto.swift
//  Snaptime
//
//  Created by Bowon Han on 7/12/24.
//

import Foundation

struct CommonResponseDtoListFindAllAlbumsResDto: Codable {
    let msg: String
    var result: [FindAllAlbumsResDto]
}


struct FindAllAlbumsResDto: Codable {
    var id: Int
    var name: String
    var photoUrl: String
}
