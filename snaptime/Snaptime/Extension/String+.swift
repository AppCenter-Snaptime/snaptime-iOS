//
//  String+.swift
//  Snaptime
//
//  Created by 이대현 on 7/8/24.
//

import Foundation

extension String {
    func toDateString() -> String? {
        // 문자열 파싱
        // Before
        // 2024-07-08T16:37:40.637357
        // After
        // 2024.07.08
        let arr = self.split(separator: "T")
        if arr.isEmpty { return nil }
        return arr[0].replacingOccurrences(of: "-", with: ".")
    }
}
