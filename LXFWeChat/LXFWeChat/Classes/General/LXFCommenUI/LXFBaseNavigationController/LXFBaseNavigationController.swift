//
//  LXFBaseNavigationController.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2016/12/24.
//  Copyright © 2016年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import UIKit

class LXFBaseNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置导航栏样式
        navigationBar.barStyle = .black
        navigationBar.barTintColor = kNavBarBgColor
        
        // 标题样式
        let bar = UINavigationBar.appearance()
        bar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName : UIFont.systemFont(ofSize: 19)
        ]
        
        // 设置返回按钮的样式
        navigationBar.tintColor = UIColor.white     // 设置返回标识器的颜色
        let barItem = UIBarButtonItem.appearance()
        barItem.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.white], for: .normal)  // 返回按钮文字样式
    }
}
