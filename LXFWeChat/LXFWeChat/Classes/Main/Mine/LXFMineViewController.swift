//
//  LXFMineViewController.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2016/12/24.
//  Copyright © 2016年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import UIKit

fileprivate let headerH: CGFloat = 22.0
fileprivate let cellH: CGFloat = 44.0

class LXFMineViewController: LXFSettingController {
    
    // MARK:- 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化
        self.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 设置cell的数据
        self.models = LXFUIDataHelper.getMineVCData()
        
        self.tableView.reloadData()
    }
}

// MARK:- 初始化
extension LXFMineViewController {
    fileprivate func setup() {
        // 设置标题
        navigationItem.title = "我"
        
        isAvatar = true
        
        // 添加tableView
        view.addSubview(self.tableView)
    }
}

// MARK:- UITableViewDelegate
extension LXFMineViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0  {    // 个人
            LXFLog("查看个人资料")
            self.pushViewController(LXFProfileViewController())
        } else if indexPath.section == 3 {    // 设置
            LXFLog("设置")
            self.pushViewController(LXFSettingViewController())
        }
    }
}
