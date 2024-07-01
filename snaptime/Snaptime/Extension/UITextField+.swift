//
//  UITextField+.swift
//  Snaptime
//
//  Created by 이대현 on 7/1/24.
//

import UIKit

extension UITextField {
    func addLeftPadding(_ padding : Int) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: Int(self.frame.height)))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
