//
//  TopTapBarCollectionViewCell.swift
//  Snaptime
//
//  Created by Bowon Han on 2/28/24.
//

import UIKit
import SnapKit

final class TopTapBarCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayouts()
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let tapButtonTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .light)
        label.textAlignment = .center
        
        return label
    }()
    
    func configTitle(_ title: String) {
        self.tapButtonTitle.text = title
    }
    
    private func setupLayouts() {
        addSubview(tapButtonTitle)
    }
    
    private func setupConstraints() {
        tapButtonTitle.snp.makeConstraints {        
            $0.edges.equalToSuperview()
        }
    }
}
