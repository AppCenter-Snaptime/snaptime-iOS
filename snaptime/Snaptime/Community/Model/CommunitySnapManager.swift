//
//  CommunitySnapManager.swift
//  Snaptime
//
//  Created by Bowon Han on 5/29/24.
//

import Foundation

class CommunitySnapManager {
    var snap = CommunitySnapModel(msg: "", result: [])
    
    static let shared = CommunitySnapManager()
    
    private init() {}
}
