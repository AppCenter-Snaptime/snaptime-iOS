//
//  FindSnapPreviewResDto.swift
//  Snaptime
//
//  Created by Bowon Han on 7/25/24.
//

import Foundation

struct FindSnapPreviewResDto: Codable {
    var snapId: Int
    var oneLineJournal: String
    var snapPhotoURL: String
    var snapCreatedDate: String
}
