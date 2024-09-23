//
//  TagTableViewCell.swift
//  Snaptime
//
//  Created by Bowon Han on 9/23/24.
//

import UIKit
import SnapKit

final class TagTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupLayouts()
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private lazy var profileImage: RoundImageView = {
        let imageView = RoundImageView()
        imageView.backgroundColor = .snaptimeGray
        
        return imageView
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "한보원"
        label.font = .systemFont(ofSize: 15, weight: .medium)
        
        return label
    }()
    
    func configData(tagInfo: FindTagUserResDto) {
        userNameLabel.text = tagInfo.tagUserName
    }
    
    private func setupLayouts() {
        [profileImage, userNameLabel].forEach {
            addSubview($0)
        }
    }
    
    private func setupConstraints() {
        profileImage.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(15)
            $0.left.equalToSuperview().offset(25)
            $0.width.equalTo(profileImage.snp.height)
            $0.height.equalTo(40)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(profileImage.snp.centerY)
            $0.left.equalTo(profileImage.snp.right).offset(15)
        }
    }
}
