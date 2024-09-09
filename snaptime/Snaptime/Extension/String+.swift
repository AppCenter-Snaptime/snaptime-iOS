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
    
    var isValidEmail: Bool {
        let emailRegExp = "^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegExp).evaluate(with: self)
    }
    
    var isValidPassword: Bool {
        let passwordRegExp = "(?=.*[A-Za-z])(?=.*[0-9]).{8,20}"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegExp).evaluate(with: self)
    }
    
    var isVaildDate: Bool {
        let components = self.split(separator: ".")
        if components.count == 3 {
            let year = components[0]
            let month = components[1]
            let day = components[2]
            return year.count == 4 && month.count == 2 && day.count == 2
        }
        return false
    }
}
