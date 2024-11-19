//
//  CommentSupplementaryFooterView.swift
//  Snaptime
//
//  Created by 이대현 on 4/3/24.
//

import SnapKit
import UIKit

final class CommentSupplementaryFooterView: UICollectionReusableView {
    var action: (()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setLayout()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        replyShowingButton.isHidden = true
    }
    
    private lazy var replyShowingButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(hexCode: "747474"), for: .normal)
        button.setTitle("----- 답글 보기", for: .normal)
        button.titleLabel?.font = UIFont(name: SuitFont.medium, size: 12)
        button.isHidden = true
        button.addAction(UIAction { [weak self] _ in
            guard let action = self?.action else { return }
            action()
        }, for: .touchUpInside)
        
        return button
    }()
    
    func changeButtonIsHidden() {
        replyShowingButton.isHidden = false
    }
    
    func setupHideButton(isHidden: Bool) {
        let buttonTitle = isHidden ? "----- 답글 보기" : "----- 답글 가리기"
        replyShowingButton.setTitle(buttonTitle, for: .normal)
    }

    private func setLayout() {
        self.addSubview(replyShowingButton)
    }
    
    private func setConstraints() {
        replyShowingButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(4)
            $0.bottom.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
        }
    }
}
