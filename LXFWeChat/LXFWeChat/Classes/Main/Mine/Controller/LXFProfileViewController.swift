//
//  LXFProfileViewController.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2017/1/29.
//  Copyright © 2017年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import UIKit

class LXFProfileViewController: LXFSettingController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化
        self.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 设置cell的数据
        self.models = LXFUIDataHelper.getProfileData()
        self.tableView.reloadData()
    }
}

// MARK:- 初始化
extension LXFProfileViewController {
    fileprivate func setup() {
        // 设置标题
        navigationItem.title = "个人信息"
        
        self.isSubAvatar = true
        
        // 添加tableView
        view.addSubview(self.tableView)
    }
}

// MARK:- 事件处理
extension LXFProfileViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0: // 头像
                LXFLog("头像")
                self.pushViewController(LXFAvatarViewController())
            case 1: // 名字
                LXFLog("名字")
                self.pushViewController(LXFNickNameViewController())
            case 2: // 微信号
                LXFLog("微信号")
            case 3: // 我的二维码
                LXFLog("我的二维码")
                self.pushViewController(LXFQRCodeViewController())
            case 4: // 我的地址
                LXFLog("我的地址")
            default:
                break
            }
        } else {
            switch indexPath.row {
            case 0: // 性别
                LXFLog("性别")
                self.pushViewController(LXFGenderViewController())
            case 1: // 地区
                LXFLog("地区")
            case 2: // 个性签名
                LXFLog("个性签名")
            default:
                break
            }
        }
    }
}

