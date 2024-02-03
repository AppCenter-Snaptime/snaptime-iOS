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
    
    private let profileTestLabel : UILabel = {
        let label = UILabel()
        label.text = "profile 화면"
        
        return label
    }()
    
    private lazy var contextButton : UIButton = {
        let button = UIButton()
        button.setTitle("tab", for: .normal)
        button.setTitleColor(.black, for: .normal)
        
        return button
    }()
    
    override func setupLayouts() {
        super.setupLayouts()
        
        [profileTestLabel,
         contextButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        profileTestLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(70)
            $0.centerX.equalToSuperview()
        }
        
        contextButton.snp.makeConstraints {
            $0.top.equalTo(profileTestLabel.snp.bottom).offset(60)
            $0.centerX.equalToSuperview()
        }
    }
}
