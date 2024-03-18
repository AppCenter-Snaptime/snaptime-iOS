//
//  NotificationViewController.swift
//  Snaptime
//
//  Created by Bowon Han on 3/18/24.
//

import UIKit
import SnapKit

protocol NotificationViewControllerDelegate: AnyObject {
    func presentNotification()
}

final class NotificationViewController: BaseViewController {
    weak var delegate: NotificationViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private lazy var notificationView = CommentView()
    private lazy var previewImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "SnapExample")
        
        return imageView
    }()
    
    override func setupLayouts() {
        super.setupLayouts()
        
        [notificationView,
         previewImage].forEach {
            view.addSubview($0)
        }
        
        notificationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(14)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.right.equalTo(previewImage.snp.left).offset(-15)
        }
        
        previewImage.snp.makeConstraints {
            $0.centerY.equalTo(notificationView.snp.centerY)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.height.equalTo(55)
            $0.width.equalTo(49)
        }
    }
}
