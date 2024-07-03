//
//  RoundImageView.swift
//  Snaptime
//
//  Created by 이대현 on 7/1/24.
//

import UIKit

final class RoundImageView: UIImageView {
    override func layoutSubviews() {
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }
}
