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
        label.font = .systemFont(ofSize: 12)
        label.textColor = UIColor(hexCode: "747474")
        label.text = "----- 답글 가리기"
        return label
    }()
    
    func show() {
        setLayout()
        setConstraints()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        self.addSubview(replyShowingLabel)
    }
    
    private func setConstraints() {
        replyShowingLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
        }
    }
}
