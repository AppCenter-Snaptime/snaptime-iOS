//
//  AlbumDetailCollectionViewCell.swift
//  snaptime
//
//  Created by Bowon Han on 2/14/24.
//

import UIKit
import SnapKit

final class AlbumDetailCollectionViewCell : UICollectionViewCell {
    private var dateLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        
        return label
    }()
    
    private var snapImage : UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .snaptimeGray
        
        return imageView
    }()
    
    private lazy var tagPeople : UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        
        return button
    }()
    
    private var oneLineDiary : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.textAlignment = .natural
        label.numberOfLines = 2
        
        return label
    }()
    
    private lazy var commentButton : UIButton = {
        let button = UIButton()
        button.setTitle("댓글보기", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayouts()
        setConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.configReuseDateLabel(date: nil)
        self.configReuseSnapImage(imageURL: nil)
        self.configReuseTagButtonText(nickname: nil)
        self.configReuseOneLineDiaryLabel(oneLineDiary: nil)
    }
    
    func configReuseDateLabel(date: String?) {
        self.dateLabel.text = date
    }
    
    func configReuseSnapImage(imageURL: String?) {
    
    }
    
    func configReuseTagButtonText(nickname: String?) {
        self.tagPeople.setTitle(nickname, for: .normal)
    }
    
    func configReuseOneLineDiaryLabel(oneLineDiary: String?) {
        self.oneLineDiary.text = oneLineDiary
    }
    
    private func setLayouts() {
        [dateLabel,
         snapImage,
         tagPeople,
         oneLineDiary,
         commentButton].forEach {
            addSubview($0)
        }
    }
    
    private func setConstraints() {
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        snapImage.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(300)
            $0.height.equalTo(440)
        }
        
        tagPeople.snp.makeConstraints {
            $0.top.equalTo(snapImage.snp.bottom).offset(19)
            $0.leading.equalTo(snapImage.snp.leading)
            $0.height.equalTo(16)
        }
        
        oneLineDiary.snp.makeConstraints {
            $0.top.equalTo(tagPeople.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(300)
            $0.height.equalTo(40)
        }
        
        commentButton.snp.makeConstraints {
            $0.top.equalTo(oneLineDiary.snp.bottom).offset(10)
            $0.leading.equalTo(oneLineDiary.snp.leading)
            $0.height.equalTo(16)
        }
    }
}
