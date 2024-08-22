//
//  FollowViewController.swift
//  Snaptime
//
//  Created by Bowon Han on 7/5/24.
//

import UIKit
import SnapKit

protocol FollowViewControllerDelegate: AnyObject {
    func presentProfile(target: ProfileTarget, loginId: String)
    func backToPrevious()
}

enum FollowTarget {
    case following
    case follower
    
    var description: String {
        switch self {
        case .following:
            return "FOLLOWING"
        case .follower:
            return "FOLLOWER"
        }
    }
}

final class FollowViewController: BaseViewController {
    weak var delegate: FollowViewControllerDelegate?
    private var friendList: [FriendInfo] = []
    
    private let target: FollowTarget
    private let loginId: String
    private var unfollowLoginId: String?
    
    init(target: FollowTarget, loginId: String) {
        self.target = target
        self.loginId = loginId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFriendList()
        setNavigationBar()
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
        config.image = UIImage(systemName: "chevron.backward")
        
        button.configuration = config
        button.addAction(UIAction { [weak self] _ in
            self?.delegate?.backToPrevious()
        }, for: .touchUpInside)
        
        return button
    }()
    
    private lazy var followTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(FollowTableViewCell.self, forCellReuseIdentifier: FollowTableViewCell.identifier)

        return tableView
    }()
    
    private func followButtonAction(name: String, loginId: String) {
        show(
            alertText: " \(name)님을 언팔로우 하시겠어요?",
            cancelButtonText: "취소하기",
            confirmButtonText: "언팔로우",
            identifier: "unfollow"
        )
        
        self.unfollowLoginId = loginId
    }
    
    // MARK: - 네트워크 로직
    private func fetchFriendList(keyword: String? = "") {
        guard let keyword = keyword else { return }
        
        APIService.fetchFollow(
            type: target.description,
            loginId: loginId,
            keyword: keyword,
            pageNum: 1
        ).performRequest(responseType: CommonResponseDtoListFindFriendResDto.self) { result in
            switch result {
            case .success(let result):
                DispatchQueue.main.async {
                    self.friendList = result.result.friendInfoResDtos
                    self.followTableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func setNavigationBar() {
        self.showNavigationBar()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.titleView = searchBar
    }
    
    // MARK: - layout 설정
    override func setupLayouts() {
        super.setupLayouts()
        
        view.addSubview(followTableView)
    }
    
    // MARK: - constraints 설정
    override func setupConstraints() {
        super.setupConstraints()
        
        followTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension FollowViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = followTableView.dequeueReusableCell(
            withIdentifier: FollowTableViewCell.identifier,
            for: indexPath
        ) as? FollowTableViewCell else {
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
                        
        // TODO: 추후 수정 필요
        cell.configData(data: friendList[indexPath.row])
        cell.setAction(action: followButtonAction)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedLoginId = friendList[indexPath.row].foundLoginId
        
//        guard let selectedLoginId = selectedLoginId else { return }
        
        if selectedLoginId == ProfileBasicUserDefaults().loginId
        {
            self.delegate?.presentProfile(target: .myself, loginId: selectedLoginId)
        }
        
        else {
            self.delegate?.presentProfile(target: .others, loginId: selectedLoginId)
        }
    }
}

extension FollowViewController: CustomAlertDelegate {
    func action(identifier: String) {
        guard let unfollowLoginId = self.unfollowLoginId else { return }
        
        APIService.deleteFollowing(loginId: unfollowLoginId).performRequest(responseType: CommonResDtoVoid.self) { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.friendList = self.removeFriend(byLoginId: unfollowLoginId, from: self.friendList)
                    self.followTableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func removeFriend(byLoginId loginId: String, from friends: [FriendInfo]) -> [FriendInfo] {
        return friends.filter { $0.foundLoginId != loginId }
    }
    
    func exit(identifier: String) {}
}

// MARK: -
extension FollowViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard let text = searchBar.text else { return }
        print(text)
        fetchFriendList(keyword: text)
    }
}
