//
//  CommentSupplementaryFooterView.swift
//  Snaptime
//
//  Created by 이대현 on 4/3/24.
//

import SnapKit
import UIKit

final class CommentSupplementaryFooterView: UICollectionReusableView {
    private lazy var replyShowingLabel: UILabel = {
        let label = UILabel()
        label.text = "답글 3개 더 보기"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        // TODO: test
        self.backgroundColor = .blue
        
        self.addSubview(replyShowingLabel)
    }
    
    private func setConstraints() {
        replyShowingLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
        }
    }
}
