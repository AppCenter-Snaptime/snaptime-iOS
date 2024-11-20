//
//  SearchViewController.swift
//  Snaptime
//
//  Created by Bowon Han on 8/5/24.
//

import UIKit
import SnapKit

protocol SearchViewControllerDelegate: AnyObject {
    func backToPrevious()
    func presentProfile(target: ProfileTarget, email: String)
}

final class SearchViewController: BaseViewController {
    weak var delegate: SearchViewControllerDelegate?
    private var userList: [UserFindByNameResDto] = []
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBar()
    }
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "검색하기"
        searchBar.backgroundColor = .white
        searchBar.barTintColor = .white
        searchBar.delegate = self
        
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = UIColor.white
            textfield.layer.borderWidth = 1
            textfield.layer.cornerRadius = 10
            textfield.layer.masksToBounds = true
            textfield.font = UIFont(name: SuitFont.semiBold, size: 16)
            textfield.layer.borderColor = UIColor.init(hexCode: "bcbcbc").cgColor
            textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
            textfield.textColor = UIColor.black
            
            /// 왼쪽 아이콘 이미지넣기
            if let leftView = textfield.leftView as? UIImageView {
                leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
                leftView.tintColor = UIColor.init(hexCode: "4b4b4b")
            }
        }
        
        return searchBar
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.filled()
        config.baseForegroundColor = .black
        config.baseBackgroundColor = .white
        config.image = UIImage(systemName: "arrow.left")
        
        button.configuration = config
        button.addAction(UIAction { [weak self] _ in
            self?.delegate?.backToPrevious()
        }, for: .touchUpInside)
        
        return button
    }()
    
    private lazy var searchResultCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    private func fetchSearchUserList(pageNum: Int, keyword: String) {
        APIService.fetchSearchUserInfo(pageNum: pageNum, 
                                       keyword: keyword).performRequest(
                                        responseType: CommonResponseDtoUserPagingResDto.self
                                       ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let result):
                    self.userList = result.result.userFindByNameResDtos
                    self.searchResultCollectionView.reloadData()
                case .failure(let error):
                    print(error)
                    self.userList = []
                    self.searchResultCollectionView.reloadData()
                }
            }
        }
    }
    
    private func setNavigationBar() {
        self.showNavigationBar()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.titleView = searchBar
    }
    
    override func setupLayouts() {
        super.setupLayouts()
        
        [searchResultCollectionView].forEach {
            view.addSubview($0)
        }
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        searchResultCollectionView.snp.makeConstraints {
            $0.top.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension SearchViewController {
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
            
            let inset = CGFloat(5)
            /// 하나의 item 설정
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)

            /// 주 그룹 설정
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(70))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            ///  section 설정
            let section = NSCollectionLayoutSection(group: group)

            return section
        }
        return layout
    }
}

// MARK: - Collection View Extension
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = searchResultCollectionView.dequeueReusableCell(
            withReuseIdentifier: SearchResultCollectionViewCell.identifier,
            for: indexPath
        ) as? SearchResultCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configData(userInfo: userList[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let email = userList[indexPath.row].foundEmail
        
        if ProfileBasicUserDefaults().email == email {
            delegate?.presentProfile(target: .myself, email: email)
        }
        
        else {
            delegate?.presentProfile(target: .others, email: email)
        }
    }
}

// MARK: -
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard let text = searchBar.text else { return }
        fetchSearchUserList(pageNum: 1, keyword: text)
    }
}
