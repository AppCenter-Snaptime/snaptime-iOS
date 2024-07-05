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
    }
    
    private lazy var followTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(FollowTableViewCell.self, forCellReuseIdentifier: FollowTableViewCell.identifier)

        return tableView
    }()
    
    override func setupLayouts() {
        super.setupLayouts()
        
        view.addSubview(followTableView)
    }
    
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
        
        // TODO: 추후 수정 필요
        cell.configData(target: target)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
}

