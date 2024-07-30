//
//  SnapTagListViewController.swift
//  Snaptime
//
//  Created by Bowon Han on 4/2/24.
//

import UIKit
import SnapKit

protocol SnapTagListViewControllerDelegate: AnyObject {
    func presentSnapTagList()
}

final class SnapTagListViewController: BaseViewController {
    weak var delegate: SnapTagListViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private lazy var tagListSearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "사람 검색하기"
        searchBar.delegate = self
        return searchBar
    }()
    
    private lazy var recentTagLabel: UILabel = {
        let label = UILabel()
        label.text = "최근 태그한 사람"
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor.init(hexCode: "#8b8b8b")
        
        return label
    }()
    
    private lazy var addTagListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(AddTagListCollectionViewCell.self, forCellWithReuseIdentifier: AddTagListCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    override func setupLayouts() {
        super.setupLayouts()
        
        [tagListSearchBar,
         recentTagLabel,
         addTagListCollectionView].forEach {
            view.addSubview($0)
        }
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        tagListSearchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            $0.left.right.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(36)
        }
        
        recentTagLabel.snp.makeConstraints {
            $0.top.equalTo(tagListSearchBar.snp.bottom).offset(16)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        addTagListCollectionView.snp.makeConstraints {
            $0.top.equalTo(recentTagLabel.snp.bottom).offset(8)
            $0.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension SnapTagListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: AddTagListCollectionViewCell.identifier,
            for: indexPath
        ) as? AddTagListCollectionViewCell else { return UICollectionViewCell() }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
}

extension SnapTagListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        
        return CGSize(width: width, height: width/6)
    }
}

extension SnapTagListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
        guard let text = searchBar.text else { return }
        print(text)
        APIService.fetchFollow(type: "FOLLOWING", loginId: "eogus4658", keyword: text, pageNum: 1).performRequest { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let result):
                    if let result = result as? CommonResponseDtoListFindFriendResDto {
                        print(result.result.friendInfos)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
