//
//  LXFRecentSessionModel.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2017/1/17.
//  Copyright © 2017年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import UIKit

class LXFRecentSessionModel: NSObject {
    // 最近会话
    var recentSession: NIMRecentSession? {
        didSet {
            session = recentSession?.session
            lastMessage = recentSession?.lastMessage
            unreadCount = recentSession?.unreadCount ?? 0
        }
    }
    // 当前会话
    fileprivate var session: NIMSession? { didSet {setSession()} }
    // 最后一条消息
    fileprivate var lastMessage: NIMMessage? { didSet {setLastMsg()} }
    // 未读消息数
    var unreadCount: Int = 0
    
    
    var avatarPath: String?
    var title: String?
    var subTitle: String?
    var time: String?
}

// MARK:- 提取数据
extension LXFRecentSessionModel {
    // MARK: setSession
    fileprivate func setSession() {
        guard let user = LXFWeChatTools.shared.getFriendInfo(userId: session?.sessionId ?? "") else {
            return
        }
        avatarPath = user.userInfo?.avatarUrl
        title = user.alias ?? user.userInfo?.nickName
        LXFLog("头像地址 --- \(user.userInfo?.avatarUrl)")
    }
    
    // MARK: setMessage
    fileprivate func setLastMsg() {
        let chatMsgModel = LXFChatMsgModel()
        chatMsgModel.message = lastMessage
        switch chatMsgModel.modelType {
        case .text:
            subTitle = chatMsgModel.text
        case .image:
            subTitle = "[图片]"
        case .video:
            subTitle = "[小视频]"
        case .audio:
            subTitle = "[语音]"
        default:
            break
        }
        
        time = LXFChatMsgTimeHelper.shared.chatTimeString(with: chatMsgModel.time)
    }
}
