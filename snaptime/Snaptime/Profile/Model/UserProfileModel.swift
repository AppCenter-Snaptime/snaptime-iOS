//
//  UserProfileResponseDTO.swift
//  Snaptime
//
//  Created by Bowon Han on 5/13/24.
//

import Foundation

struct UserProfileResponseDTO: Decodable {
    var userId: String
    var userName: String
    var profileURL: String
}
