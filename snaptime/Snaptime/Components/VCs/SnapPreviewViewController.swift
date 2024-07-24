//
//  SnapPreviewViewController.swift
//  Snaptime
//
//  Created by Bowon Han on 6/21/24.
//

import Alamofire
import UIKit
import SnapKit

protocol SnapPreviewViewControllerDelegate: AnyObject {
    func presentSnap(snapId: Int)
}

final class SnapPreviewViewController: BaseViewController {
    weak var delegate: SnapPreviewViewControllerDelegate?
    private let albumID: Int
    private var snapPreviews: [FindSnapPreviewResDto] = []
    
    init(albumID: Int) {
        self.albumID = albumID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "최근항목"
        self.fetchAlbumDetail(id: self.albumID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.fetchAlbumDetail(id: self.albumID)
    }
    
    private func fetchAlbumDetail(id: Int) {
        APIService.fetchSnapPreview(albumId: id).performRequest { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let snapPreview):
                    if let snapPreview = snapPreview as? CommonResponseDtoFindAlbumResDto {
                        self.snapPreviews = snapPreview.result.snap
                    }
                    self.albumDetailCollectionView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private lazy var albumDetailCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 30
        layout.minimumInteritemSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SnapPreviewCollectionViewCell.self, forCellWithReuseIdentifier: SnapPreviewCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    override func setupLayouts() {
        [albumDetailCollectionView].forEach {
            view.addSubview($0)
        }
    }
    
    override func setupConstraints() {
        albumDetailCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension SnapPreviewViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SnapPreviewCollectionViewCell.identifier,
            for: indexPath
        ) as? SnapPreviewCollectionViewCell else { return UICollectionViewCell() }
        cell.setupUI(snapPreviews[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return snapPreviews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.presentSnap(snapId: snapPreviews[indexPath.row].snapId)
    }
}

extension SnapPreviewViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let numberOfItemsPerRow: CGFloat = 2
        let spacing: CGFloat = 20 // width spacing
        let availableWidth = width - spacing * (numberOfItemsPerRow + 1)
        let itemDimension = floor(availableWidth / numberOfItemsPerRow)
        return CGSize(width: itemDimension, height: itemDimension + 100)
    }
}
