//
//  DetailAlbumViewController.swift
//  snaptime
//
//  Created by Bowon Han on 2/1/24.
//

import UIKit
import SnapKit

protocol DetailAlbumNavigation : AnyObject {

}

final class DetailAlbumViewController : BaseViewController {
    weak var coordinator : DetailAlbumNavigation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    init(coordinator: DetailAlbumNavigation) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let homeDetailTestLabel : UILabel = {
        let label = UILabel()
        label.text = "home detail"
        
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
        
        [homeDetailTestLabel,
         contextButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        homeDetailTestLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(70)
            $0.centerX.equalToSuperview()
        }
        
        contextButton.snp.makeConstraints {
            $0.top.equalTo(homeDetailTestLabel.snp.bottom).offset(60)
            $0.centerX.equalToSuperview()
        }
    }
}

