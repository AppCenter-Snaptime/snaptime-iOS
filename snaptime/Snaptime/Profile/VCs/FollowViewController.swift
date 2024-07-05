//
//  FollowViewController.swift
//  Snaptime
//
//  Created by Bowon Han on 7/5/24.
//

import UIKit
import SnapKit

protocol FollowViewControllerDelegate: AnyObject {
    
}

enum FollowTarget {
    case following
    case follower
}

final class FollowViewController: BaseViewController {
    weak var delegate: FollowViewControllerDelegate?
    private var friendList: [FindFriendResDto] = []
    
    private let target: FollowTarget
    
    init(target: FollowTarget) {
        self.target = target
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchFriendList()
    }
    
    private lazy var followTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(FollowTableViewCell.self, forCellReuseIdentifier: FollowTableViewCell.identifier)

        return tableView
    }()
    
    // MARK: - 네트워크 로직
    private func fetchFriendList() {
        APIService.fetchFollow(type: "FOLLOWING", keyword: "", pageNum: 1).performRequest { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let result):
                    if let result = result as? CommonResponseDtoListFindFriendResDto {
                        self.friendList = result.result
                    }
                    
                    self.followTableView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
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
        cell.configData(target: target, data: friendList[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendList.count
    }
}

