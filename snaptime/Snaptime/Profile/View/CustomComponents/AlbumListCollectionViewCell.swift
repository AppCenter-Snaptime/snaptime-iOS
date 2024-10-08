//
//  AlbumCollectionViewCell.swift
//  Snaptime
//
//  Created by Bowon Han on 2/22/24.
//

import UIKit
import SnapKit
import Kingfisher

/// AlbumList내부 collectionview의 Custom Cell -> MainAlbum의 CollectionViewCell과 합쳐 하나로 만드는 과정 필요!!
final class AlbumListCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayouts()
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        snapImageView1.image = UIImage()
        snapImageView2.image = UIImage()
    }
    
    private var imageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        
        return stackView
    }()
    
    private var snapImageView1: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .snaptimeGray
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private var snapImageView2: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .snaptimeGray
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        
        return label
    }()
    
    func setCellData(data: AlbumSnapResDto) {
        descriptionLabel.text = data.albumName
        
        if data.snapUrlList.count == 2 {
            APIService.loadImage(data: data.snapUrlList[0], imageView: snapImageView1)
            APIService.loadImage(data: data.snapUrlList[1], imageView: snapImageView2)
        }
        
        else if data.snapUrlList.count == 1 {
            APIService.loadImage(data: data.snapUrlList[0], imageView: snapImageView1)
        }
    }
    
    //MARK: - setup UI
    private func setupLayouts() {
        self.layer.shadowColor = UIColor(hexCode: "c4c4c4").cgColor
        self.layer.shadowPath = UIBezierPath(rect: CGRect(x: self.bounds.origin.x - 1.5, 
                                                        y: self.bounds.origin.y + 10,
                                                        width: self.bounds.width + 3,
                                                        height: self.bounds.height - 7)).cgPath
        self.layer.shadowOpacity = 0.7
        self.layer.shadowRadius = 7
        self.contentView.layer.cornerRadius = 15
        self.contentView.layer.masksToBounds = true
        self.contentView.backgroundColor = .white
        
        [snapImageView1,snapImageView2].forEach {
            imageStackView.addArrangedSubview($0)
        }
        
        [imageStackView,
         descriptionLabel].forEach {
            self.contentView.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        imageStackView.snp.makeConstraints {
            $0.left.top.right.equalTo(self.safeAreaLayoutGuide)
            $0.height.equalTo(snapImageView1.snp.width)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.left.equalTo(imageStackView).offset(15)
            $0.centerY.equalTo(imageStackView.snp.bottom).offset(18)
        }
    }
}
