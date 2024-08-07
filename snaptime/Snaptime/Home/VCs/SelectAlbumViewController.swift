//
//  SelectAlbumViewController.swift
//  Snaptime
//
//  Created by 이대현 on 7/30/24.
//

import UIKit
import SnapKit

protocol SelectAlbumViewControllerDelegate: AnyObject {
    func backToPrevious()
}

final class SelectAlbumViewController: BaseViewController {
    private lazy var mainAlbumCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 30
        layout.minimumInteritemSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 20, right: 20)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(AlbumSelectCollectionViewCell.self, forCellWithReuseIdentifier: AlbumSelectCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var deleteButton = {
        let button = SnapTimeCustomButton("삭제")
        button.backgroundColor = UIColor(hexCode: "FF5454")
        button.addAction(UIAction { _ in
            self.deleteAlbum()
            self.delegate?.backToPrevious()
        }, for: .touchUpInside)
        return button
    }()
    
    // -------------------------
    
    weak var delegate: SelectAlbumViewControllerDelegate?
    var albumData: [Album] = []
    var albumChecked: [Bool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchAlbumList()
    }
    
    private func fetchAlbumList() {
        APIService.fetchAlbumList.performRequest { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let albumList):
                    if let albumList = albumList as? CommonResponseDtoListFindAllAlbumsResDto {
                        self.albumData = albumList.result.map { Album($0) }
                        self.albumChecked = Array(repeating: false, count: self.albumData.count)
                    }
                    
                    self.mainAlbumCollectionView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func deleteAlbum() {
        var deleteAlbums: [Album] = []
        for i in 0..<self.albumData.count {
            if self.albumChecked[i] {
                deleteAlbums.append(self.albumData[i])
            }
        }
        print(deleteAlbums)
        for album in deleteAlbums {
            APIService.deleteAlbum(albumId: album.id).performRequest { result in
                switch result {
                case .success(_):
                    print(album.name + " 앨범 삭제 성공")
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    // MARK: -- Layout & Constraints
    override func setupLayouts() {
        super.setupLayouts()
        [
            mainAlbumCollectionView,
            deleteButton
        ].forEach {
            view.addSubview($0)
        }
        
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        deleteButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.height.equalTo(50)
        }
        
        mainAlbumCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(25)
            $0.left.right.equalTo(deleteButton)
            $0.bottom.equalTo(deleteButton.snp.top).offset(-10)
//            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension SelectAlbumViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: AlbumSelectCollectionViewCell.identifier,
            for: indexPath
        ) as? AlbumSelectCollectionViewCell else { return UICollectionViewCell() }
        cell.setupUI(albumData[indexPath.row])
        cell.check(albumChecked[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("select row")
        self.albumChecked[indexPath.row].toggle()
        self.mainAlbumCollectionView.reloadData()
    }
}

extension SelectAlbumViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let numberOfItemsPerRow: CGFloat = 2
        let spacing: CGFloat = 23
        let availableWidth = width - spacing * (numberOfItemsPerRow + 1)
        let itemDimension = floor(availableWidth / numberOfItemsPerRow)
        return CGSize(width: itemDimension, height: itemDimension + 50)
    }
}
