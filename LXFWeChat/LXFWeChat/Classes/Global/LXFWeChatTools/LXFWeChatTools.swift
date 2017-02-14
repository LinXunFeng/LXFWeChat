//
//  LXFWeChatTools.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2016/12/27.
//  Copyright © 2016年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import UIKit

/* ============================== UserDefaults ============================== */
fileprivate let kWechatAccount = "wechatAccount"
fileprivate let kWechatPassword = "wechatPassword"
fileprivate let kWechatUserId = "wechatUserId"

class LXFWeChatTools: NSObject {
    // 当前聊天的userId
    var currentChatUserId: String?
    
    // MARK:- 代理
    // MARK: 音频代理
    weak var mediaDelegate: LXFWeChatToolsMediaDelegate?
    // weak var chatDelegate:
    
    static let shared: LXFWeChatTools = {
        let tools = LXFWeChatTools()
        NIMSDK.shared().chatManager.add(tools as NIMChatManagerDelegate)
        NIMSDK.shared().userManager.add(tools as NIMUserManagerDelegate)
        NIMSDK.shared().loginManager.add(tools as NIMLoginManagerDelegate)
        NIMSDK.shared().mediaManager.addDelegate(tools as NIMMediaManagerDelgate)
        NIMSDK.shared().conversationManager.add(tools as NIMConversationManagerDelegate)
        return tools
    }()
}

// MARK:- 登录相关
extension LXFWeChatTools {
    // MARK: 手动登录
    func login(with account: String, pwd: String, errorBlock:@escaping (Error?) -> ()) {
        // 如果pwd MD5加密 => pwd.MD5String()
        NIMSDK.shared().loginManager.login(account, token: pwd, completion: {[unowned self] (error) in
            if error == nil {
                LXFLog("登录成功")
                // 存储账号和密码
                self.storeCurrentUser(account, pwd)
                
                errorBlock(nil)
            } else {
                errorBlock(error)
                LXFLog((error as! NSError).code)
            }
        })
    }
    // MARK: 自动登录
    func autoLogin() -> (Bool) {
        // 取出账号和密码
        var account: String?
        var pwd: String?
        self.readCurrentUser { (myAccount, myPwd) in
            account = myAccount
            pwd = myPwd
        }
        if account == nil || pwd == nil { // 没有保存账号或密码
            LXFLog("没有保存账号或密码")
            return false
        } else {    // 自动登录
            LXFLog("启用自动登录")
            NIMSDK.shared().loginManager.autoLogin(account!, token: pwd!)
            return true
        }
    }
}

// MARK:- 信息操作
extension LXFWeChatTools {
    // MARK: 获取当前用户的userId
    func getCurrentUserId() -> String {
        let userId = NIMSDK.shared().loginManager.currentAccount()
        return userId
    }
    
    // MARK: 获取当前用户的资料
    func getMineInfo() -> NIMUser? {
        return NIMSDK.shared().userManager.userInfo(self.getCurrentUserId())
    }
    
    // MARK:- 获取好友信息
    func getFriendInfo(userId: String) -> NIMUser? {
        return NIMSDK.shared().userManager.userInfo(userId)
    }
    
    // MARK:- 从服务器获取好友信息
    func refreshFriends() {
        guard let users = self.getMyFriends() else {return}
        var userIds: [String] = []
        for user in users {
            userIds.append(user.userId ?? "")
        }
        NIMSDK.shared().userManager.fetchUserInfos(userIds) { (users, error) in
            if error != nil {
                LXFLog(error)
            } else {
                LXFLog("获取成功，下次启动程序会自动更新好友信息")
            }
        }
    }
}

// MARK:- 好友操作
extension LXFWeChatTools {
    // MARK: 获取我的好友
    func getMyFriends() -> [NIMUser]? {
        return NIMSDK.shared().userManager.myFriends()
    }
    // MARK: 添加好友请求
    func addFriend(_ userID: String, message: String, completion:@escaping (Error?)->()) {
        let request = NIMUserRequest()
        request.userId = userID
        request.operation = .request
        request.message = message
        NIMSDK.shared().userManager.requestFriend(request) { (error) in
            completion(error)
        }
    }
    // MARK: 删除好友
    func deleteFriend(_ userID: String, completion:@escaping (Error?)->()) {
        NIMSDK.shared().userManager.deleteFriend(userID) { (error) in
            completion(error)
        }
    }
    
    func test() {
        let info = [
            NSNumber(value: 3): "林洵锋"
        ]
        NIMSDK.shared().userManager.updateMyUserInfo(info) { (error) in
            LXFLog(error)
        }
    }
    
}


// MARK:- 代理
// MARK: 登录相关代理
extension LXFWeChatTools: NIMLoginManagerDelegate {
    // MARK: 自动登录失败的回调
    func onAutoLoginFailed(_ error: Error) {
        
        let errorCode = (error as NSError).code
        if errorCode == 302 {
            // 用户名密码错误导致自动登录失败
            trans2UserVC() // 跳转到用户界面
            LXFProgressHUD.lxf_showError(withStatus: "用户名或密码错误")
        } else if errorCode == 417 {
            // 已有一端登录导致自动登录失败
            trans2UserVC() // 跳转到用户界面
            LXFProgressHUD.lxf_showWarning(withStatus: "您的账号已在其它设备上登录")
        } else if errorCode == 422 {
            LXFProgressHUD.lxf_showError(withStatus: "您的账号已被禁用")
        }else {
            // 这个情况不用关心
            LXFProgressHUD.lxf_showError(withStatus: "这个情况不用关心")
        }
        LXFLog(errorCode)
    }
}
// MARK: 好友管理相关代理
extension LXFWeChatTools: NIMUserManagerDelegate {
    // MARK: 好友添加成功的回调
    func onFriendChanged(_ user: NIMUser) {
        // 该回调在成功 添加/删除 好友后都会调用
        // 好友添加成功后，会触发回调
        // 解除成功后，会同时修改本地的缓存数据，并触发回调
        LXFLog("好友列表更新：\(user.alias)")
        // 发送更新好友列表的通知
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNoteContactUpdateFriends), object: self, userInfo: nil)
    }
    // MARK: 修改用户资料成功的回调
    func onUserInfoChanged(_ user: NIMUser) {
        LXFLog("修改资料")
        // 刷新用户/好友信息
        self.refreshFriends()
    }
}

// MARK:- 一些处理
extension LXFWeChatTools {
    // MARK: 存储用户信息
    func storeCurrentUser(_ account: String, _ password: String) {
        // 存储账号和密码
        UserDefaults.standard.set(account, forKey: kWechatAccount)
        UserDefaults.standard.set(password, forKey: kWechatPassword)
    }
    // MARK: 读取用户信息
    func readCurrentUser(info:@escaping (String?, String?)->Void) {
        // 取出账号和密码
        let account = UserDefaults.standard.string(forKey: kWechatAccount)
        let pwd = UserDefaults.standard.string(forKey: kWechatPassword)
        info(account, pwd)
    }
    // MARK: 跳转到用户界面
    func trans2UserVC() {
        UIApplication.shared.keyWindow?.rootViewController = LXFUserViewController()
    }
}
