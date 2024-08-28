//
//  SelectBrandViewController.swift
//  Snaptime
//
//  Created by Bowon Han on 8/28/24.
//

import UIKit
import SnapKit

protocol SelectBrandViewControllerDelegate: AnyObject {
    
}

final class SelectBrandViewController: BaseViewController {
    weak var delegate: SelectBrandViewControllerDelegate?
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private let instructionLabel: UILabel = {
        let label = UILabel()
        label.text = "브랜드를 선택해주세요"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var brandCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 20, left: 60, bottom: 20, right: 60)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SelectBrandCollectionViewCell.self, forCellWithReuseIdentifier: SelectBrandCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    private lazy var nextButton = SnapTimeCustomButton("다음")
    
    override func setupLayouts() {
        super.setupLayouts()
        
        [instructionLabel, 
         brandCollectionView,
         nextButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        instructionLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(107)
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(30)
        }
        
        brandCollectionView.snp.makeConstraints {
            $0.top.equalTo(instructionLabel.snp.bottom).offset(48)
            $0.left.right.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(nextButton.snp.top).offset(20)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-30)
            $0.left.right.equalTo(view.safeAreaLayoutGuide).inset(30)
            $0.height.equalTo(50)
        }
    }
}

extension SelectBrandViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = brandCollectionView.dequeueReusableCell(
            withReuseIdentifier: SelectBrandCollectionViewCell.identifier,
            for: indexPath
        ) as? SelectBrandCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let brandName = ["하루필름", "포토시그니처", "Studio808", "1Percent"]
        let brandImageName = ["haruBrandImage", "photoSigBrandImage", "studio808BrandImage", "1percentBrandImage"]
        
        cell.configData(brandName: brandName[indexPath.row], brandImageName: brandImageName[indexPath.row])
        
        return cell
    }
}

extension SelectBrandViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 120
        let numberOfItemsPerRow: CGFloat = 2
        let spacing: CGFloat = 5
        let availableWidth = width - spacing * (numberOfItemsPerRow + 1)
        let itemDimension = floor(availableWidth / numberOfItemsPerRow)
        
        return CGSize(width: itemDimension, height: itemDimension + 20)
    }
}
