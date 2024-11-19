//
//  SelectBrandViewController.swift
//  Snaptime
//
//  Created by Bowon Han on 8/28/24.
//

import UIKit
import SnapKit

protocol SelectBrandViewControllerDelegate: AnyObject {
    func presentQRReaderView(didSelectedBrand: FourCutBrand)
}

final class SelectBrandViewController: BaseViewController {
    weak var delegate: SelectBrandViewControllerDelegate?
    
    private var selectedBrand: Int = 0
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isTappedNextButton()
    }
    
    private let instructionLabel: UILabel = {
        let label = UILabel()
        label.text = "브랜드를 선택해주세요"
        label.font = UIFont(name: SuitFont.semiBold, size: 20)
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
    
    private func isTappedNextButton() {
        nextButton.addAction(UIAction { [weak self] _ in
            guard let brandIndex = self?.selectedBrand,
                  let brand = FourCutBrand(index: brandIndex) else { return }

            self?.delegate?.presentQRReaderView(didSelectedBrand: brand)
        }, for: .touchUpInside)
    }
    
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
        
        guard let brand = FourCutBrand(index: indexPath.row) else { return UICollectionViewCell() }
        
        cell.configData(brandName: brand.toUIName(), brandImageName: brand.toImageName())
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedBrand = indexPath.row
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
