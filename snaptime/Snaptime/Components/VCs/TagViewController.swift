//
//  TagViewController.swift
//  Snaptime
//
//  Created by Bowon Han on 9/23/24.
//

import UIKit
import SnapKit

protocol TagViewControllerDelegate: AnyObject {
    func presentProfile(target: ProfileTarget, email: String)
}

final class TagViewController: BaseViewController {
    weak var delegate: TagViewControllerDelegate?
    
    private var tagList: [FindTagUserResDto]
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    init(tagList: [FindTagUserResDto]) {
        self.tagList = tagList
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private lazy var tagTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TagTableViewCell.self, forCellReuseIdentifier: TagTableViewCell.identifier)
        tableView.separatorStyle = .none

        return tableView
    }()
    
    override func setupLayouts() {
        super.setupLayouts()
        
        view.addSubview(tagTableView)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        tagTableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension TagViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tagList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tagTableView.dequeueReusableCell(
            withIdentifier: TagTableViewCell.identifier,
            for: indexPath
        ) as? TagTableViewCell else {
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        cell.configData(tagInfo: tagList[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let loginId = tagList[indexPath.row].tagUserEmail
        var profileTarget: ProfileTarget = .others
        
        if ProfileBasicUserDefaults().email == loginId {
            profileTarget = .myself
        }
        
        delegate?.presentProfile(target: profileTarget, email: loginId)
    }
}
