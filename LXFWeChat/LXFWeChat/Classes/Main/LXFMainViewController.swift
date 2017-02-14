//
//  LXFMainViewController.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2016/12/24.
//  Copyright © 2016年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import UIKit

class LXFMainViewController: UITabBarController {
    
    let textColor = RGBA(r: 0.51, g: 0.51, b: 0.51, a: 1.00)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 创建子控制器
        self.createSubViewControllers()
        
        // 设置tabBarItem选中与未选中的文字颜色
        UITabBarItem.appearance().setTitleTextAttributes(NSDictionary(object:textColor, forKey:NSForegroundColorAttributeName as NSCopying) as? [String : AnyObject], for:UIControlState.normal);
        
        UITabBarItem.appearance().setTitleTextAttributes(NSDictionary(object:kBtnGreen, forKey:NSForegroundColorAttributeName as NSCopying) as? [String : AnyObject], for:UIControlState.selected);
    }
    
    // MARK:- 创建子控制器
    func createSubViewControllers() {
        
        let wechatVC = LXFWechatViewController()
        let wechatItem: UITabBarItem = UITabBarItem(title: "微信", image: #imageLiteral(resourceName: "tabbar_mainframe").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "tabbar_mainframeHL").withRenderingMode(.alwaysOriginal))
        wechatVC.tabBarItem = wechatItem
        let wechatNavVC = LXFBaseNavigationController(rootViewController: wechatVC)
        
        let contactVC = LXFContactViewController()
        let contactItem: UITabBarItem = UITabBarItem(title: "通讯录", image: #imageLiteral(resourceName: "tabbar_contacts").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "tabbar_contactsHL").withRenderingMode(.alwaysOriginal))
        contactVC.tabBarItem = contactItem
        let contactNavVC = LXFBaseNavigationController(rootViewController: contactVC)
        
        let findVC = LXFFindViewController()
        let findItem: UITabBarItem = UITabBarItem(title: "发现", image: #imageLiteral(resourceName: "tabbar_discover").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "tabbar_discoverHL").withRenderingMode(.alwaysOriginal))
        findVC.tabBarItem = findItem
        let findNavVC = LXFBaseNavigationController(rootViewController: findVC)
        
        let mineVC = LXFMineViewController()
        let mineItem: UITabBarItem = UITabBarItem(title: "我", image: #imageLiteral(resourceName: "tabbar_me").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "tabbar_meHL").withRenderingMode(.alwaysOriginal))
        mineVC.tabBarItem = mineItem
        let mineNavVC = LXFBaseNavigationController(rootViewController: mineVC)
        
        let tabArray = [wechatNavVC, contactNavVC, findNavVC, mineNavVC]
        self.viewControllers = tabArray
    }
}


