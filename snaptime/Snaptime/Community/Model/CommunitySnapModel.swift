//
//  CommunitySnapModel.swift
//  Snaptime
//
//  Created by Bowon Han on 5/29/24.
//

import Foundation

struct CommunitySnapModel: Codable {
    let msg: String
    var result: [Result]
    
    struct Result: Codable {
        var snapId: Int
        var oneLineJournal: String
        var snapPhotoURL: String
        var snapCreatedDate: String
        var snapModifiedDate: String
        var loginId: String
        var profilePhotoURL: String
        var userName: String
    }
}
