//
//  LXFGenderViewController.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2017/1/30.
//  Copyright © 2017年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import UIKit

class LXFGenderViewController: LXFSettingController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化
        self.setup()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK:- 初始化
extension LXFGenderViewController {
    fileprivate func setup() {
        // 设置标题
        navigationItem.title = "性别"
        
        // 设置cell的数据
//        let mineInfo = LXFWeChatTools.shared.getMineInfo()
//        let genderEnum = (mineInfo?.userInfo?.gender) ?? .unknown
//        let index: Int?
        
        self.models = [
            [
                LXFSettingCellModel(icon: nil, title: "男", tipImg: "MoreCheck", tipTitle: nil, type: .check),
                LXFSettingCellModel(icon: nil, title: "女", tipImg: nil, tipTitle: nil, type: .check)
            ]
        ]
        
        // 注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(goBack(_:)), name: NSNotification.Name(rawValue: kNoteWeChatGoBack), object: nil)
        
        // 添加tableView
        view.addSubview(self.tableView)
    }
}

// MARK:- 事件处理
extension LXFGenderViewController {
    @objc fileprivate func goBack(_ note: Notification) {
        guard let type = note.object as? LXFWeChatToolsUpdateType else {
            return
        }
        if type == .avatar {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
}

extension LXFGenderViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        
        var gender: LXFWeChatToolsGender!
        switch indexPath.row {
        case 0:
            LXFLog("男")
            gender = .male
        default:
            LXFLog("女")
            gender = .female
        }
        LXFProgressHUD.lxf_showWithStatus("正在为您修改性别")
        LXFWeChatTools.shared.updateGender(with: gender)
    }
}

