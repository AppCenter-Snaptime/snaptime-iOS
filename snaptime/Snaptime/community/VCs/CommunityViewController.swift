//
//  CommunityViewController.swift
//  snaptime
//
//  Created by Bowon Han on 2/1/24.
//

import UIKit
import SnapKit

protocol CommunityNavigation : AnyObject {
    func presentCommunity()
}

final class CommunityViewController : BaseViewController {
    weak var coordinator : CommunityCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    init(coordinator: CommunityCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let communityTestLabel : UILabel = {
        let label = UILabel()
        label.text = "community 화면"
        
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
        
        [communityTestLabel,
         contextButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        communityTestLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(70)
            $0.centerX.equalToSuperview()
        }
        
        contextButton.snp.makeConstraints {
            $0.top.equalTo(communityTestLabel.snp.bottom).offset(60)
            $0.centerX.equalToSuperview()
        }
    }
}
