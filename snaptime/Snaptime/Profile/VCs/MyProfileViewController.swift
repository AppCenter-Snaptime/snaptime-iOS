//
//  MyProfileViewController.swift
//  snaptime
//
//  Created by Bowon Han on 2/1/24.
//

import UIKit
import SnapKit

protocol MyProfileNavigation : AnyObject {
    func presentMyProfile()
}

final class MyProfileViewController : BaseViewController {
    weak var coordinator : MyProfileNavigation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    init(coordinator: MyProfileNavigation) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - configUI
    private let iconLabel : UILabel = {
        let label = UILabel()
        label.text = "Profile"
        label.textColor = .snaptimeBlue
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .left
        
        return label
    }()
    
    private let notificationButton : UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .systemBackground
        config.baseForegroundColor = .black
        config.image = UIImage(systemName: "bell")
        button.configuration = config
        
        return button
    }()
    
    private let profileStatusView = ProfileStatusView(target: .myself)
    private let albumAndTagListView = AlbumAndTagListView()
    
    // MARK: - setupUI
    override func setupLayouts() {
        super.setupLayouts()
        [iconLabel,
         notificationButton,
         profileStatusView,
         albumAndTagListView].forEach {
            view.addSubview($0)
        }
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        iconLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(25)
            $0.width.equalTo(80)
            $0.height.equalTo(32)
        }
        
        notificationButton.snp.makeConstraints {
            $0.centerY.equalTo(iconLabel.snp.centerY)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-25)
            $0.height.width.equalTo(32)
        }
        
        profileStatusView.snp.makeConstraints {
            $0.top.equalTo(iconLabel.snp.bottom).offset(10.5)
            $0.left.right.equalTo(view.safeAreaLayoutGuide)
        }
        
        albumAndTagListView.snp.makeConstraints {
            $0.top.equalTo(profileStatusView.snp.bottom).offset(8)
            $0.left.right.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
