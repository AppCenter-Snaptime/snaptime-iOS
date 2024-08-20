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
    func backToPrevious(albumId: Int)
    func backToRoot()
}

enum AlbumSelectMode {
    case albumSelect
    case moveSnap
    case deleteAlbum
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
    
    private lazy var processButton = {
        let button = SnapTimeCustomButton("")
        button.backgroundColor = UIColor(hexCode: "FF5454")
        button.addAction(UIAction { _ in
            self.deleteAlbum()
            self.delegate?.backToPrevious()
        }, for: .touchUpInside)
        return button
    }()
    
    // -------------------------
    
    var selectMode: AlbumSelectMode
    weak var delegate: SelectAlbumViewControllerDelegate?
    var albumData: [Album] = []
    var albumChecked: [Bool] = []
    var snap: FindSnapResDto? = nil
    
    init(selectMode: AlbumSelectMode, snap: FindSnapResDto? = nil) {
        self.selectMode = selectMode
        self.snap = snap
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchAlbumList()
        self.setupUI()
    }
    
    private func fetchAlbumList() {
        APIService.fetchAlbumList.performRequest(responseType: CommonResponseDtoListFindAllAlbumsResDto.self) { result in
            switch result {
            case .success(let albumList):
                DispatchQueue.main.async {
                    self.albumData = albumList.result.map { Album($0) }
                    self.albumChecked = Array(repeating: false, count: self.albumData.count)
                    self.mainAlbumCollectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func setupUI() {
        if self.selectMode == .deleteAlbum {
            self.processButton.setTitle("앨범 삭제", for: .normal)
            self.processButton.addAction(UIAction { _ in
                self.deleteAlbum()
                self.delegate?.backToRoot()
            }, for: .touchUpInside)
        }
        else if self.selectMode == .moveSnap {
            self.processButton.setTitle("폴더 이동", for: .normal)
            self.processButton.addAction(UIAction { _ in
                self.moveSnap()
                self.delegate?.backToRoot()
            }, for: .touchUpInside)
        }
        
        else {
            self.processButton.setTitle("폴더 선택", for: .normal)
            self.processButton.addAction(UIAction { _ in
                guard self.selectMode == .albumSelect else { return }
                var selectAlbums: [Album] = []
                for i in 0..<self.albumData.count {
                    if self.albumChecked[i] {
                        selectAlbums.append(self.albumData[i])
                    }
                }
                guard let albumId = selectAlbums.first?.id else { return }
                self.delegate?.backToPrevious(albumId: albumId)
            }, for: .touchUpInside)
        }
    }
    
    private func deleteAlbum() {
        guard self.selectMode == .deleteAlbum else { return }
        
        var deleteAlbums: [Album] = []
        for i in 0..<self.albumData.count {
            if self.albumChecked[i] {
                deleteAlbums.append(self.albumData[i])
            }
        }

        for album in deleteAlbums {
            APIService.deleteAlbum(albumId: album.id).performRequest(responseType: CommonResDtoVoid.self) { result in
                switch result {
                case .success(_):
                    print(album.name + " 앨범 삭제 성공")
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func moveSnap() {
        guard self.selectMode == .moveSnap else { return }
        
        var selectAlbums: [Album] = []
        for i in 0..<self.albumData.count {
            if self.albumChecked[i] {
                selectAlbums.append(self.albumData[i])
            }
        }
        print(selectAlbums)
        guard selectAlbums.count == 1 else {
            print("앨범 1개 선택되지 않음")
            return
        }
        
        guard let snap = self.snap,
              let albumId = selectAlbums.first?.id else { return }
        
        APIService.moveSnap(snapId: snap.snapId, albumId: albumId).performRequest(responseType: CommonResDtoVoid.self) { result in
            switch result {
            case .success:
                print("앨범 이동 성공!")
            case .failure(let error):
                print("moveSnap error : ")
                print(error)
            }
        }
    }
    
    // MARK: -- Layout & Constraints
    override func setupLayouts() {
        super.setupLayouts()
        [
            mainAlbumCollectionView,
            processButton
        ].forEach {
            view.addSubview($0)
        }
        
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        processButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.height.equalTo(50)
        }
        
        mainAlbumCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(25)
            $0.left.right.equalTo(processButton)
            $0.bottom.equalTo(processButton.snp.top).offset(-10)
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
