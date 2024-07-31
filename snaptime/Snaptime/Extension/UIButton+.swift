//
//  UIButton+.swift
//  Snaptime
//
//  Created by Bowon Han on 7/31/24.
//

import UIKit

extension UIButton {
    func setUnderline() {
        guard let title = title(for: .normal) else { return }
        let attributedString = NSMutableAttributedString(string: title)
        attributedString.addAttribute(.underlineStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: NSRange(location: 0, length: title.count)
        )
        
        attributedString.addAttribute(.foregroundColor,
                                      value: UIColor.lightGray,
                                      range: NSRange(location: 0, length: title.count))

        setAttributedTitle(attributedString, for: .normal)
    }
}
