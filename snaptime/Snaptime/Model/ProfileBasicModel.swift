//
//  ProfileBasicModel.swift
//  Snaptime
//
//  Created by Bowon Han on 5/13/24.
//

import Foundation

struct ProfileBasicModel: Codable {
    var loginId: String
}

extension ProfileBasicModel {
    static let profile = ProfileBasicModel(loginId: "bowon0000")
}
