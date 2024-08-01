//
//  SnapTagListViewController.swift
//  Snaptime
//
//  Created by Bowon Han on 4/2/24.
//

import UIKit
import SnapKit

protocol SnapTagListViewControllerDelegate: AnyObject {
    func backToAddSnapView(tagList: [FriendInfo])
}

final class SnapTagListViewController: BaseViewController {
    weak var delegate: SnapTagListViewControllerDelegate?
    private var searchResults: [FriendInfo] = []
    
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
        label.text = "검색 결과"
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
        cell.setupUI(info: searchResults[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // NOTE: 일단 태그 하나 선택시 앞 화면으로 돌아가게 설정. 이후 multiselect 가능하게 변경해야 함
        delegate?.backToAddSnapView(tagList: [searchResults[indexPath.row]])
    }
}

extension SnapTagListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        
        return CGSize(width: width, height: width/6)
    }
}

extension SnapTagListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("textDidChange")
        guard let text = searchBar.text,
              let loginId = ProfileBasicUserDefaults().loginId
        else { return }
  
        APIService.fetchFollow(type: FollowTarget.following.description, 
                               loginId:loginId,
                               keyword: text,
                               pageNum: 1).performRequest { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let result):
                    if let result = result as? CommonResponseDtoListFindFriendResDto {
                        print(result.result.friendInfoResDtos)
                        self.searchResults = result.result.friendInfoResDtos
                        self.addTagListCollectionView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                    self.searchResults = []
                    self.addTagListCollectionView.reloadData()
                }
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarSearchButtonClicked")
        dismissKeyboard()
        
        guard let text = searchBar.text,
              let loginId = ProfileBasicUserDefaults().loginId
        else { return }
        
        APIService.fetchFollow(type: FollowTarget.following.description,
                               loginId: loginId,
                               keyword: text,
                               pageNum: 1).performRequest { result in
            
            DispatchQueue.main.async {
                switch result {
                case .success(let result):
                    if let result = result as? CommonResponseDtoListFindFriendResDto {
                        print(result.result.friendInfoResDtos)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
