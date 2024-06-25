//
//  CommunitySnapResponse.swift
//  Snaptime
//
//  Created by Bowon Han on 5/29/24.
//

import Foundation

struct CommunitySnapResponse: Codable {
    let msg: String
    var result: [CommunitySnapResDTO]
}

struct CommunitySnapResDTO: Codable {
    var snapId: Int
    var oneLineJournal: String
    var snapPhotoURL: String
    var snapCreatedDate: String
    var snapModifiedDate: String
    var loginId: String
    var profilePhotoURL: String
    var userName: String
}
