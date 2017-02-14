//
//  LXFSettingController.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2016/12/29.
//  Copyright © 2016年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import UIKit

fileprivate let headerH: CGFloat = 22.0
fileprivate let cellH: CGFloat = 44.0
fileprivate let LXFSettingNormalCellID = "LXFSettingNormalCellID"
fileprivate let LXFSettingAvatarCellID = "LXFSettingAvatarCellID"
fileprivate let LXFSettingMiddleCellID = "LXFSettingMiddleCellID"

fileprivate let kSettingCellID = "settingCellID"


class LXFSettingController: LXFBaseController {

    // MARK:- 标记属性
    var isAvatar: Bool = false
    var isSubAvatar: Bool = false
    
    // MARK:- 懒加载
    // tableView
    lazy var tableView: UITableView = { [unowned self] in
        let tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = kSectionColor
        tableView.contentInset = UIEdgeInsetsMake(58, 0, 44, 0)
        tableView.scrollIndicatorInsets = UIEdgeInsetsMake(64, 0, 44, 0)
        let footView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.4))
        footView.backgroundColor = kSplitLineColor
        tableView.tableFooterView = footView
        return tableView
        }()
    // models
    lazy var models: [[LXFSettingCellModel]] = {
        return [[LXFSettingCellModel]]()
    }()
    
    // MARK:- 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化
        self.setup()
    }
}

// MARK:- 初始化
extension LXFSettingController {
    fileprivate func setup() {
        
        // 注册cellID
        tableView.register(LXFSettingNormalCell.self, forCellReuseIdentifier: LXFSettingNormalCellID)
        tableView.register(LXFSettingAvatarCell.self, forCellReuseIdentifier: LXFSettingAvatarCellID)
        tableView.register(LXFSettingMiddleCell.self, forCellReuseIdentifier: LXFSettingMiddleCellID)
        
        // 添加tableView
        view.addSubview(self.tableView)
    }
}

extension LXFSettingController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.models.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.models[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.models[indexPath.section][indexPath.row]
        
        var cell: LXFSettingBaseCell?
        var cellID: String!
        if model.type == .avatar {
            cellID = LXFSettingAvatarCellID
        } else if model.type == .middle {
            cellID = LXFSettingMiddleCellID
        } else {
            cellID = LXFSettingNormalCellID
        }
        cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? LXFSettingBaseCell
        
        // 设置数据
        cell?.model = model
        
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0  && isAvatar {   // 头像
            return cellH * 2
        } else if indexPath.section == 0 && indexPath.row == 0  && isSubAvatar {
            return cellH * 2 - 8
        }
        return cellH
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerH
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // 添加分割线
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: headerH))
        let splitLineH: CGFloat = 0.5
        for i in 0..<2 {
            let margin: CGFloat = i == 0 ? 0 : headerH - splitLineH
            let splitLine = UIView()
            // 设置分割线的颜色
            if i == 0 && section == 0 {
                splitLine.backgroundColor = UIColor.clear
            } else {
                splitLine.backgroundColor = kSplitLineColor
            }
            view.addSubview(splitLine)
            splitLine.snp.makeConstraints({ (make) in
                make.left.right.equalTo(view)
                make.height.equalTo(splitLineH)
                make.top.equalTo(view).offset(margin)
            })
        }
        return view
    }
}

extension LXFSettingController {
    func pushViewController(_ controller: UIViewController, isHidesBottomBarWhenPushed isHeide: Bool = true) {
        controller.hidesBottomBarWhenPushed = isHeide
        navigationController?.pushViewController(controller, animated: true)
    }
}

