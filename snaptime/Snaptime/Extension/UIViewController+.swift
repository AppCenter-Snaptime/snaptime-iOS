//
//  UIViewController+.swift
//  Snaptime
//
//  Created by Bowon Han on 7/22/24.
//

import UIKit

extension UIViewController {
    
    /// navigationBar를 숨기는 메서드
    func hideNavigationBar() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    /// 숨긴 navigationBar를 보여주는 메서드
    func showNavigationBar() {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    /// 화면 빈공간 클릭 시 keyboard 내려가는 메서드
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
