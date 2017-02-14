//
//  LXFSettingViewController.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2017/1/25.
//  Copyright © 2017年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import UIKit

class LXFSettingViewController: LXFSettingController {

    // MARK:- 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化
        self.setup()
    }
    
}

// MARK:- 初始化
extension LXFSettingViewController {
    fileprivate func setup() {
        // 设置标题
        navigationItem.title = "设置"
        
        // 设置cell的数据
        self.models = LXFUIDataHelper.getSettingVCData()
        
        isAvatar = false
        
        // 添加tableView
        view.addSubview(self.tableView)
    }
}

extension LXFSettingViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        
        LXFLog("点击了 --- \(indexPath.row)")
        
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                LXFLog("帐号与安全")
            default:
                break
            }
        } else if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                LXFLog("新消息通知")
            case 1:
                LXFLog("隐私")
            case 2:
                LXFLog("通知")
            default:
                break
            }
        } else if indexPath.section == 2 {
            switch indexPath.row {
            case 0:
                LXFLog("帮助与反馈")
                let webView = WKWebViewController()
                webView.loadUrlSting(string: "https://kf.qq.com/touch/product/wechat_app.html?scene_id=kf338")
                self.pushViewController(webView)
            case 1:
                LXFLog("关于微信")
                self.pushViewController(LXFAboutViewController())
            default:
                break
            }
        } else {
            LXFLog("退出登录")
        }
    }
}
