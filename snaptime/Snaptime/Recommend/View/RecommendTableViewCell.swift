//
//  RecommendTableViewCell.swift
//  Snaptime
//
//  Created by 이대현 on 2/22/24.
//

import SnapKit
import UIKit

final class RecommendTableViewCell: UITableViewCell {
    private let sectionView = RecommendSectionView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayouts()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayouts() {
        self.contentView.addSubview(sectionView)
    }
    
    private func setupConstraints() {
        sectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
