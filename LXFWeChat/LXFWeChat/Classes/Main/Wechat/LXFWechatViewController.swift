//
//  LXFWechatViewController.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2016/12/24.
//  Copyright © 2016年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import UIKit

// cellID
fileprivate let LXFRecentSessionCellID = "LXFRecentSessionCellID"

class LXFWechatViewController: LXFBaseController {
    
    // MARK:- 懒加载
    // 搜索控制器
    var searchController: UISearchController?
    
    // dataArr
    lazy var dataArr: [LXFRecentSessionModel] = {
        var datas = [LXFRecentSessionModel]()
        guard let recentSessions = LXFWeChatTools.shared.getAllRecentSession() else {
            return datas
        }
        for session in recentSessions {
            let model = LXFRecentSessionModel()
            model.recentSession = session
            datas.append(model)
        }
        return datas
    }()
    
    // tableView
    lazy var tableView: UITableView = { [unowned self] in
        let tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 68.0
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsetsMake(64, 0, 44, 0)
        tableView.scrollIndicatorInsets = UIEdgeInsetsMake(64, 0, 44, 0)
        tableView.separatorInset = UIEdgeInsetsMake(0, 8, 0, 0)
        tableView.tableFooterView = UIView()
        return tableView
    }()
    // 菜单
    weak var popMenu: LXFPopMenu?

    // MARK:- 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化
        self.setup()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // 隐藏菜单
        popMenu?.dismissPopMenuAnimatedOnMenu(selected: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 设置未读数
        let item = self.tabBarController?.tabBar.items?[0]
        let count = LXFWeChatTools.shared.getAllUnreadCount()
        if count > 0 {
            item?.badgeValue = "\(count)"
        } else {
            item?.badgeValue = nil
        }
        
        // 设置小红点
        self.tabBarController?.tabBar.showBadgOn(index: 2)
    }
}

// MARK:- 初始化
extension LXFWechatViewController {
    fileprivate func setup() {
        // 设置标题
        navigationItem.title = "微信"
        // 设置右侧按钮
        createRightBarBtnItem(icon: #imageLiteral(resourceName: "barbuttonicon_add"), method: #selector(popMenu(_:)))
        
        // 搜索控制器
        let searchResultVC = LXFBaseController()
        searchResultVC.view.backgroundColor = UIColor.red
        let searchController = LXFSearchController(searchResultsController: searchResultVC)
        self.searchController = searchController
        
        // 添加tableView
        tableView.tableHeaderView = searchController.searchBar
        view.addSubview(self.tableView)
        
        // 注册cellID
        tableView.register(LXFRecentSessionCell.self, forCellReuseIdentifier: LXFRecentSessionCellID)
    }
}

// MARK:- 事件处理
extension LXFWechatViewController {
    @objc func popMenu(_ sender: UIButton) {
        var popMenuItems: [LXFPopMenuItem] = [LXFPopMenuItem]()
        for i in 0..<4 {
            var image: UIImage!
            var title: String!
            switch i {
            case 0:
                image = #imageLiteral(resourceName: "contacts_add_newmessage")
                title = "发起群聊"
            case 1:
                image = #imageLiteral(resourceName: "contacts_add_friend")
                title = "添加朋友"
            case 2:
                image = #imageLiteral(resourceName: "contacts_add_scan")
                title = "扫一扫"
            case 3:
                image = #imageLiteral(resourceName: "contacts_add_mycard")
                title = "收付款"
            default: break
            }
            let popMenuItem = LXFPopMenuItem(image: image, title: title)
            popMenuItems.append(popMenuItem)
        }
        self.popMenu = LXFPopMenu(menus: popMenuItems)
        // 弹出菜单
        popMenu?.showMenu(on: self.view, at: CGPoint.zero)
        popMenu?.popMenuDidSelectedBlock = { (index, menuItem) in
            LXFLog("\(index), \(menuItem)")
        }
    }
}

// MARK:- UITableViewDataSource
extension LXFWechatViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: LXFRecentSessionCellID) as? LXFRecentSessionCell
        
        let model = dataArr[indexPath.row]
        cell?.model = model
        
        return cell!;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
