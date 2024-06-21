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
    func presentCommentVC()
}

final class SnapViewController: BaseViewController {
    weak var delegate: SnapViewControllerDelegate?
    private let snapId: Int
    
    private var snap: FindSnapResDto = FindSnapResDto(id: 0, oneLineJournal: "", photoURL: "", albumName: "", userUid: "")
    
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
        let url = "http://na2ru2.me:6308/snap/\(id)"
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
                    let result = try decoder.decode(CommonResponseDtoFindSnapResDto.self, from: data)
                    print(result)
                    self.snap = result.result
                    DispatchQueue.main.async {
                        self.snapCollectionView.reloadData()
                    }
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(String(describing: error.errorDescription))
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

extension SnapViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = snapCollectionView.dequeueReusableCell(
            withReuseIdentifier: SnapCollectionViewCell.identifier,
            for: indexPath
        ) as? SnapCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.delegate = self
        cell.configureDataForHome(data: snap) // 서버 측에 snap을 반환하는 데이터 형식 동일하게 보내줄 수 있는지 요청
        
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
    func didTapCommentButton() {
        delegate?.presentCommentVC()
    }
}
