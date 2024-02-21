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
        
        self.tabAlbumButton()
        self.tabTagButton()
    }
    
    init(coordinator: MyProfileNavigation) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    private let tabButtonStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        
        return stackView
    }()
    
    private lazy var albumTabButton = ProfileTabButton("앨범 목록")
    private lazy var tagTabButton = ProfileTabButton("태그 목록")
    
    private let indicatorView : UIView = {
        let view = UIView()
        view.backgroundColor = .black
        
        return view
    }()
    
    private func tabAlbumButton() {
        albumTabButton.tabButtonAction = { [weak self] in
            self?.indicatorView.snp.remakeConstraints {
                $0.top.equalTo((self?.tabButtonStackView.snp.bottom)!)
                $0.height.equalTo(0.7)
                $0.leading.equalToSuperview()
                $0.width.equalTo(UIScreen.main.bounds.width/2)
            }
            
            UIView.animate(
                withDuration: 0.3,
                animations: { self?.view.layoutIfNeeded() }
            )
        }
    }
    
    private func tabTagButton() {
        tagTabButton.tabButtonAction = { [weak self] in
            self?.indicatorView.snp.remakeConstraints {
                $0.top.equalTo((self?.tabButtonStackView.snp.bottom)!)
                $0.height.equalTo(0.7)
                $0.trailing.equalToSuperview()
                $0.width.equalTo(UIScreen.main.bounds.width/2)
            }
            
            UIView.animate(
                withDuration: 0.3,
                animations: { self?.view.layoutIfNeeded() }
            )
        }
    }
    
    override func setupLayouts() {
        super.setupLayouts()
        
        [albumTabButton,
         tagTabButton].forEach {
            tabButtonStackView.addArrangedSubview($0)
        }
        
        [iconLabel,
         notificationButton,
         profileStatusView,
         tabButtonStackView,
         indicatorView].forEach {
            view.addSubview($0)
        }
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        iconLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(25)
            $0.width.equalTo(80)
            $0.height.equalTo(32)
        }
        
        notificationButton.snp.makeConstraints {
            $0.centerY.equalTo(iconLabel.snp.centerY)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-25)
            $0.height.width.equalTo(32)
        }
        
        profileStatusView.snp.makeConstraints {
            $0.top.equalTo(iconLabel.snp.bottom).offset(10.5)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        tabButtonStackView.snp.makeConstraints {
            $0.top.equalTo(profileStatusView.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(40)
        }
        
        indicatorView.snp.makeConstraints {
            $0.top.equalTo(tabButtonStackView.snp.bottom)
            $0.height.equalTo(0.7)
            $0.leading.equalTo(view.safeAreaLayoutGuide)
            $0.width.equalTo(UIScreen.main.bounds.width/2)
        }
    }
}
