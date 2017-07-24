//
//  LXFWechatViewController+Notification.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2017/7/24.
//  Copyright © 2017年 林洵锋. All rights reserved.
//

import Foundation

extension LXFWechatViewController {
    func registerNote() {
        NotificationCenter.default.addObserver(self, selector: #selector(receiveMsg(_:)), name: NSNotification.Name(rawValue: kNoteChatMsgInsertMsg), object: nil)
    }
}

// MARK:- 处理全局接收到的消息，这里处理视频聊天
extension LXFWechatViewController {
    @objc fileprivate func receiveMsg(_ note: Notification) {
        guard let nimMsg = note.object as? NIMMessage else { return }
        // 收到自己发送信息的通知则不用理会
        if nimMsg.from == LXFWeChatTools.shared.getMineInfo()?.userId { return }
        
        guard let messageObj = nimMsg.messageObject else { return }
        
        if (messageObj.isKind(of: NIMCustomObject.self)) {  // 自定义消息
//            let cusObj = messageObj as! NIMCustomObject
//            guard let attachment = cusObj.attachment else { return }
//            let att = attachment as! videoChatAttachment
//            let type = att.videoType
//            LXFLog("是自定义消息 \(type)")
            // 这里暂时就只有视频聊天
            let user = LXFContactCellModel(user: LXFWeChatTools.shared.getFriendInfo(userId: nimMsg.from ?? ""))
            UIApplication.shared.keyWindow?.rootViewController?.present(LXFVideoChatController(user: user, isInitiator: false), animated: true, completion: nil)
            
        }
    }
}
