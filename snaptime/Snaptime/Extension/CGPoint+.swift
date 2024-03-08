//
//  CGPoint+.swift
//  Snaptime
//
//  Created by 이대현 on 3/8/24.
//

import Foundation

internal extension CGPoint {

    // MARK: - CGPoint+offsetBy
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        var point = self
        point.x += dx
        point.y += dy
        return point
    }
}
