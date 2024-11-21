//
//  BaseViewController.swift
//  snaptime
//
//  Created by Bowon Han on 2/1/24.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayouts()
        setupConstraints()
        setupStyles()
        hideKeyboardWhenTappedAround()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func setupLayouts() {}
    
    func setupConstraints() {}
    
    func setupStyles() {}
}
