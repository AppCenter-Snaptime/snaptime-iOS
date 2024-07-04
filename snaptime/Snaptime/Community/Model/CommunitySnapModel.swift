//
//  CommunitySnapResponse.swift
//  Snaptime
//
//  Created by Bowon Han on 5/29/24.
//

import Foundation

struct CommunitySnapResponse: Codable {
    let msg: String
    var result: [SnapResDTO]
}

