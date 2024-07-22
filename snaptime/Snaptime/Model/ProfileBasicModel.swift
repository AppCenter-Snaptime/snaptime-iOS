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
    static let profile = ProfileBasicModel(loginId: "hyeon0000")
    static let profile2 = ProfileBasicModel(loginId: "eogus4658")
}
