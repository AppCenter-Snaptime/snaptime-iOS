//
//  UIColor+.swift
//  snaptime
//
//  Created by Bowon Han on 2/6/24.
//

import UIKit

// MARK: - UIColor extension
extension UIColor {
    convenience init(hexCode: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hexCode.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
            
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
            
        assert(hexFormatted.count == 6, "Invalid hex code used.")
            
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
            
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
    
    static let snaptimeBlue : UIColor = UIColor(hexCode: "A4CEFF")
    static let snaptimeYellow : UIColor = UIColor(hexCode: "FFE483")
    static let snaptimegray : UIColor = UIColor(hexCode: "D0D0D0")
}

