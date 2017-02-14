//
//  UIViewController+Extenstion.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2016/12/28.
//  Copyright © 2016年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import Foundation

enum BarBtnItemDirection: Int {
    case left
    case right
}

extension UIViewController {
    // MARK:- 设置导航栏右侧按钮
    func createRightBarBtnItem(icon: UIImage, method: Selector ) {
        // 设置导航栏右侧按钮
        let menuBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        menuBtn.addTarget(self, action: method, for: .touchUpInside)
        menuBtn.setImage(icon, for: .normal)
        let rightBtn = UIBarButtonItem(customView: menuBtn)
        
        self.addFixedSpace(with: rightBtn, direction: .right)
    }
    
    func createRightBarBtnItem(title: String, method: Selector, titleColor: UIColor = kBtnGreen) {
        let rightBtn = self.createBarBtnItem(title: title, method: method, titleColor: titleColor)
        self.addFixedSpace(with: rightBtn, direction: .right)
    }
    
    func createLeftBarBtnItem(title: String, method: Selector?, titleColor: UIColor = UIColor.white) {
        let leftBtn = self.createBarBtnItem(title: title, method: #selector(cancel), titleColor: titleColor)
        self.addFixedSpace(with: leftBtn, direction: .left)
    }
    
    // MARK: 私有
    fileprivate func createBarBtnItem(title: String, method: Selector, titleColor: UIColor = UIColor.white) -> UIBarButtonItem {
        let originBtn = UIButton(frame: CGRect.zero)
        originBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        originBtn.setTitle(title, for: .normal)
        originBtn.setTitleColor(titleColor, for: .normal)
        originBtn.setTitleColor(titleColor.withAlphaComponent(0.5), for: .highlighted)
        originBtn.sizeToFit()
        originBtn.addTarget(self, action: method, for: .touchUpInside)
        return UIBarButtonItem(customView: originBtn)
    }
    
    fileprivate func addFixedSpace(with barItem: UIBarButtonItem, direction: BarBtnItemDirection) {
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        negativeSpacer.width = -11
        switch direction {
        case .left:
            navigationItem.leftBarButtonItems = [negativeSpacer, barItem]
        default:
            navigationItem.rightBarButtonItems = [negativeSpacer, barItem]
        }
        
    }
}
extension UIViewController {
    @objc fileprivate func cancel() {
        _ = self.navigationController?.popViewController(animated: true)
    }
}
