//
//  AlbumDetailViewController.swift
//  Snaptime
//
//  Created by Bowon Han on 4/2/24.
//

import Alamofire
import UIKit
import SnapKit

protocol SnapPreviewViewControllerDelegate: AnyObject {
    func presentAlbumSnap()
}

final class SnapPreviewViewController: BaseViewController {
    weak var delegate: SnapPreviewViewControllerDelegate?
    private let albumID: Int
    private var albumData: [Album] = [
        Album(id: 0, name: "손흥민 개쩐다", photoURL: "http://na2ru2.me:6308/photo?fileName=0522232351169_1153062499_IMG_0008.jpeg&isEncrypted=false"),
        Album(id: 1, name: "손흥민 개쩐다2", photoURL: "http://na2ru2.me:6308/photo?fileName=0522232351169_1153062499_IMG_0008.jpeg&isEncrypted=false"),
        Album(id: 2, name: "손흥민 개쩐다3", photoURL: "http://na2ru2.me:6308/photo?fileName=0522232351169_1153062499_IMG_0008.jpeg&isEncrypted=false"),
        Album(id: 3, name: "손흥민 개쩐다4", photoURL: "http://na2ru2.me:6308/photo?fileName=0522232351169_1153062499_IMG_0008.jpeg&isEncrypted=false"),
        Album(id: 4, name: "손흥민 개쩐다5", photoURL: "http://na2ru2.me:6308/photo?fileName=0522232351169_1153062499_IMG_0008.jpeg&isEncrypted=false")
    ]
    
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
    
    private func fetchAlbumDetail(id: Int) {
        let url = "http://na2ru2.me:6308/album/\(id)?album_id=\(id)"
        print(url)
        let headers: HTTPHeaders = [
            "Authorization": ACCESS_TOKEN,
            "accept": "*/*"
        ]
        AF.request(
            url,
            method: .get,
            parameters: nil,
            encoding: URLEncoding.default,
            headers: headers
        )
        .validate(statusCode: 200..<300)
        .responseJSON { response in
            switch response.result {
            case .success(let data):
                print("success")
                print(data)
                guard let data = response.data else { return }
                
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(CommonResponseDtoFindAlbumResDto.self, from: data)
                    print(result)
                    self.albumData = result.result.snap.map { Album($0) }
                    DispatchQueue.main.async {
                        self.albumDetailCollectionView.reloadData()
                    }
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(String(describing: error.errorDescription))
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
        cell.setupUI(albumData[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.presentAlbumSnap()
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
