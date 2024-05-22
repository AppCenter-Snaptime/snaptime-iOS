//
//  UserProfileModel.swift
//  Snaptime
//
//  Created by Bowon Han on 5/13/24.
//

import Foundation

struct UserProfileModel: Codable {
    let msg: String
    var result: Result
    
    struct Result: Codable {
        var userId: Int
        var userName: String
        var profileURL: String
    }
}
