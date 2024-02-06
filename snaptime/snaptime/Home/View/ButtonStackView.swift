//
//  ButtonStackView.swift
//  snaptime
//
//  Created by Bowon Han on 2/2/24.
//

import UIKit
import SnapKit

class ButtonStackView : UIView {
    private let stackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 15
        stackView.backgroundColor = .white
        
        return stackView
    }()
    
    private let mainButton = CustomTabButton("홈","house")
    private let communityButton = CustomTabButton("커뮤니티", "magnifyingglass")
    private let noneButton = CustomTabButton("미정", "square.text.square")
    private let profileButton = CustomTabButton("프로필", "person")

    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setLayout(){
        [mainButton,
         communityButton,
         noneButton,
         profileButton].forEach {
            stackView.addArrangedSubview($0)
        }
        
        [mainButton,
         communityButton,
         noneButton,
         profileButton].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(40)
            }
        }
        
        addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(self)
        }
    }
}


