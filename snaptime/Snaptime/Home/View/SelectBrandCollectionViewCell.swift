//
//  SelectBrandCollectionViewCell.swift
//  Snaptime
//
//  Created by Bowon Han on 8/28/24.
//

import UIKit
import SnapKit

final class SelectBrandCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayouts()
        setupStyles()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private lazy var brandImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let brandNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .gray
        label.text = "포토시그니처"
        
        return label
    }()
    
    func configData(brandName: String, brandImageName: String) {
        brandNameLabel.text = brandName
        brandImageView.image = UIImage(named: brandImageName)
    }
    
    private func setupStyles() {
        contentView.layer.borderColor = UIColor.init(hexCode: "E0E0E0").cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 8
    }
    
    private func setupLayouts() {
        [brandImageView,
         brandNameLabel].forEach {
            addSubview($0)
        }
        
        brandImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.right.left.equalToSuperview().inset(40)
            $0.height.equalTo(brandImageView.snp.width)
        }
        
        brandNameLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-20)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(brandImageView.snp.bottom).offset(20)
        }
    }
}
