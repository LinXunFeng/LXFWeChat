//
//  LXFChatMsgController.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2017/1/3.
//  Copyright © 2017年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import UIKit
import MJRefresh

// cellID
fileprivate let LXFChatTextCellID = "LXFChatTextCellID"
fileprivate let LXFChatImageCellID = "LXFChatImageCellID"
fileprivate let LXFChatTimeCellID = "LXFChatTimeCellID"
fileprivate let LXFChatAudioCellID = "LXFChatAudioCellID"
fileprivate let LXFChatVideoCellID = "LXFChatVideoCellID"

protocol LXFChatMsgControllerDelegate: NSObjectProtocol {
    func chatMsgVCWillBeginDragging(chatMsgVC: LXFChatMsgController)
}

class LXFChatMsgController: LXFBaseController {
    // MARK:- 属性
    // MARK: 用户模型
    var user: LXFContactCellModel?
    // MARK: 代理
    weak var delegate: LXFChatMsgControllerDelegate?
    
    // MARK:- 懒加载
    lazy var tableView: UITableView = { [unowned self] in
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.separatorInset = UIEdgeInsetsMake(64, 0, 0, 0)
        tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        // 注册cell
        tableView.register(LXFChatTextCell.classForCoder(), forCellReuseIdentifier: LXFChatTextCellID)
        tableView.register(LXFChatImageCell.classForCoder(), forCellReuseIdentifier: LXFChatImageCellID)
        tableView.register(LXFChatTimeCell.classForCoder(), forCellReuseIdentifier: LXFChatTimeCellID)
        tableView.register(LXFChatAudioCell.classForCoder(), forCellReuseIdentifier: LXFChatAudioCellID)
        tableView.register(LXFChatVideoCell.classForCoder(), forCellReuseIdentifier: LXFChatVideoCellID)
        return tableView
    }()
    
    lazy var dataArr: [LXFChatMsgModel] = {
        let history = LXFWeChatTools.shared.getLocalMsgs(userId: self.user?.userId)
        let models = LXFChatMsgDataHelper.shared.getFormatMsgs(nimMsgs: history)
        return LXFChatMsgDataHelper.shared.addTimeModel(models: models)
    }()
    
    
    // MARK:- init
    init(user: LXFContactCellModel?) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK:- 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()

        // 初始化
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scrollToBottom(animated: true)
    }
    
    deinit {
        // 移除通知
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK:- 初始化
extension LXFChatMsgController {
    // MARK: 初始
    fileprivate func setup() {
        // 添加tableView
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalTo(self.view)
        }
        
        // 设置当前聊天的userId
        LXFWeChatTools.shared.currentChatUserId = user?.userId
        
        // 注册通知
        self.registerNote()
        
        // 设置刷新
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadEarlierMsgs))
    }
}

// MARK:- 刷新加载更多
extension LXFChatMsgController {
    func loadEarlierMsgs() {
        LXFLog("加载更早的消息")
        let earlierMsgs = LXFWeChatTools.shared.getLocalMsgs(userId: user?.userId, message: dataArr.first?.message)
        guard let eMsgs = earlierMsgs else {
            return
        }
        // 没有本地消息了
        if eMsgs.count == 0 {
            var curMessage: NIMMessage? = nil
            if dataArr.count != 0 {
                curMessage = dataArr[1].message
            }
            // 加载云端消息
            LXFWeChatTools.shared.getCloudMsgs(currentMessage: curMessage, userId: user?.userId, resultBlock: { (error, messages) in
                if error != nil {
                    LXFLog(error)
                    self.tableView.mj_header.endRefreshing()
                } else {
                    guard let msgs = messages, msgs.count != 0 else {
                        self.tableView.mj_header.endRefreshing()
                        self.tableView.mj_header.isHidden = true
                        return
                    }
                    self.loadMoreMessage(msgs: msgs)
                    self.tableView.mj_header.endRefreshing()
                }
            })
        } else { // 加载更多本地消息
            self.loadMoreMessage(msgs: eMsgs)
        }
    }
    
    fileprivate func loadMoreMessage(msgs: [NIMMessage]) {
        let models = LXFChatMsgDataHelper.shared.getFormatMsgs(nimMsgs: msgs)
        let timeMsgs = LXFChatMsgDataHelper.shared.addTimeModel(models: models)
        var indexPath: IndexPath!
        if dataArr.count == 0 {
            indexPath = IndexPath(row: timeMsgs.count - 1, section: 0)
        } else {
            indexPath = IndexPath(row: timeMsgs.count, section: 0)
        }
        for timeMsg in timeMsgs.reversed() {
            self.insertRowModel(model: timeMsg, isBottom: false)
        }
        self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
        self.tableView.mj_header.endRefreshing()
    }
}


// MARK: - 数据源、代理
extension LXFChatMsgController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataArr[indexPath.row]
        
        // 时间是特例
        if model.modelType == .time {
            let cell = tableView.dequeueReusableCell(withIdentifier: LXFChatTimeCellID) as? LXFChatTimeCell
            cell?.model = model
            return cell!
        }
        
        var cell: LXFChatBaseCell?
        if model.modelType == .text {
            cell = tableView.dequeueReusableCell(withIdentifier: LXFChatTextCellID) as? LXFChatTextCell
        } else if model.modelType == .image {
            cell = tableView.dequeueReusableCell(withIdentifier: LXFChatImageCellID) as? LXFChatImageCell
        } else if model.modelType == .audio {
            cell = tableView.dequeueReusableCell(withIdentifier: LXFChatAudioCellID) as? LXFChatAudioCell
        } else if model.modelType == .video {
            cell = tableView.dequeueReusableCell(withIdentifier: LXFChatVideoCellID) as? LXFChatVideoCell
        }
        cell?.model = model
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = dataArr[indexPath.row]
        return model.cellHeight
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.chatMsgVCWillBeginDragging(chatMsgVC: self)
    }
    
}

// MARK:- 对外提供的方法
extension LXFChatMsgController {
    // MARK: 滚到底部
    func scrollToBottom(animated: Bool = false) {
        self.view.layoutIfNeeded()
        if dataArr.count > 0 {
            tableView.scrollToRow(at: IndexPath(row: dataArr.count - 1, section: 0), at: .top, animated: animated)
        }
    }
    // MARK: 插入模型数据
    func insertRowModel(model: LXFChatMsgModel, isBottom: Bool = true) {
        var indexPath: IndexPath!
        if isBottom {
            dataArr.append(model)
            indexPath = IndexPath(row: dataArr.count - 1, section: 0)
            _ = self.tableView(tableView, cellForRowAt: indexPath)
            self.insertRows([indexPath])
        } else {
            dataArr.insert(model, at: 0)
            indexPath = IndexPath(row: 0, section: 0)
            _ = self.tableView(tableView, cellForRowAt: indexPath)
            self.insertRows([indexPath], atBottom: false)
        }
    }
    // MARK:更新模型数据
    func updateRowModel(model: LXFChatMsgModel) {
        for dataModel in dataArr {
            if model.message != dataModel.message { continue }
            let indexPath = IndexPath(row: dataArr.index(of: dataModel)!, section: 0)
            self.updataRow([indexPath])
        }
    }
    // MARK:删除模型数据
    func deleteRowModel(model: LXFChatMsgModel) {
        var index = 0
        for dataModel in dataArr {
            if (model.message == dataModel.message) && (dataModel.modelType != .time) {
                let indexPath = IndexPath(row: dataArr.index(of: dataModel)!, section: 0)
                dataArr.remove(at: index)
                self.deleteRow([indexPath])
                return
            }
            index += 1
        }
    }
}

// MARK:- private Method
extension LXFChatMsgController {
    // MARK: 插入数据
    fileprivate func insertRows(_ rows: [IndexPath], atBottom: Bool = true) {
        UIView.setAnimationsEnabled(false)
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: rows, with: .none)
        self.tableView.endUpdates()
        if atBottom {
            self.scrollToBottom()
        }
        UIView.setAnimationsEnabled(true)
        LXFLog("插入数据")
    }
    
    // MARK: 更新数据
    fileprivate func updataRow(_ rows: [IndexPath]) {
        UIView.setAnimationsEnabled(false)
        self.tableView.beginUpdates()
        self.tableView.reloadRows(at: rows, with: .none)
        self.tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        LXFLog("更新数据")
    }
    
    // MARK: 删除数据
    fileprivate func deleteRow(_ rows: [IndexPath]) {
        UIView.setAnimationsEnabled(false)
        self.tableView.beginUpdates()
        self.tableView.deleteRows(at: rows, with: .none)
        self.tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        LXFLog("删除数据")
    }
}

