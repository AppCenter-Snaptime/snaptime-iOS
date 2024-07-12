//
//  SnapViewController.swift
//  Snaptime
//
//  Created by Bowon Han on 6/21/24.
//

import UIKit
import SnapKit
import Alamofire

protocol SnapViewControllerDelegate: AnyObject {
    func presentCommentVC(snap: SnapResDTO)
}

final class SnapViewController: BaseViewController {
    weak var delegate: SnapViewControllerDelegate?
    private let snapId: Int
    
    private var snap: SnapResDTO = SnapResDTO(
        snapId: 0,
        oneLineJournal: "",
        snapPhotoURL: "",
        snapCreatedDate: "",
        snapModifiedDate: "",
        loginId: "",
        profilePhotoURL: "",
        userName: ""
    )
    
    init(snapId: Int) {
        self.snapId = snapId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchSnap(id: self.snapId)
    }
    
    private func fetchSnap(id: Int) {
        APIService.fetchSnap(albumId: id).performRequest { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let snap):
                    if let snap = snap as? CommonResponseDtoFindSnapResDto {
                        self.snap = snap.result
                    }
                    self.snapCollectionView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private lazy var snapCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 30
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 30, right: 20)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(SnapCollectionViewCell.self,
                                forCellWithReuseIdentifier: SnapCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        return collectionView
    }()

    override func setupLayouts() {
        super.setupLayouts()
        
        view.addSubview(snapCollectionView)
    }
        
    override func setupConstraints() {
        super.setupConstraints()
        
        snapCollectionView.snp.makeConstraints {
            $0.top.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - extension
extension SnapViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = snapCollectionView.dequeueReusableCell(
            withReuseIdentifier: SnapCollectionViewCell.identifier,
            for: indexPath
        ) as? SnapCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.delegate = self
        cell.configureData(data: self.snap)
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
}

extension SnapViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.bounds.width
        let numberOfItemsPerRow: CGFloat = 1
        let spacing: CGFloat = 20
        let availableWidth = width - spacing * (numberOfItemsPerRow + 1)
        let itemDimension = floor(availableWidth / numberOfItemsPerRow)
        return CGSize(width: itemDimension, height: itemDimension+300)
    }
}

extension SnapViewController: SnapCollectionViewCellDelegate {
    func didTapCommentButton(snap: SnapResDTO) {
        delegate?.presentCommentVC(snap: snap)
    }
}
