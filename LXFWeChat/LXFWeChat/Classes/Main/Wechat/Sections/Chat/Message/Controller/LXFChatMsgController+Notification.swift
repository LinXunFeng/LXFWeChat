//
//  LXFChatMsgController+Notification.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2017/1/9.
//  Copyright © 2017年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import Foundation

extension LXFChatMsgController {
    // MARK: 通知
    func registerNote() {
        // 注册通知 kNoteChatMsgResendMsg
        // 收到当前聊天的用户信息 / 即将发送消息
        NotificationCenter.default.addObserver(self, selector: #selector(insertMsgNote(_:)), name: NSNotification.Name(rawValue: kNoteChatMsgInsertMsg), object: nil)
        // 更新消息状态 发送成功/失败/重发
        NotificationCenter.default.addObserver(self, selector: #selector(updateMsg(_:)), name: NSNotification.Name(rawValue: kNoteChatMsgUpdateMsg), object: nil)
        // 重发(用来删除dataArr中的数据)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteMsg(_:)), name: NSNotification.Name(rawValue: kNoteChatMsgResendMsg), object: nil)
        
        // 点击消息图片
        NotificationCenter.default.addObserver(self, selector: #selector(showImgs(_:)), name: NSNotification.Name(rawValue: kNoteChatMsgTapImg), object: nil)
        // 点击消息视频
        NotificationCenter.default.addObserver(self, selector: #selector(showVideo(_:)), name: NSNotification.Name(rawValue: kNoteChatMsgVideoPlayStart), object: nil)
    }
}

// MARK:- 通知调用的方法
extension LXFChatMsgController {
    // MARK: 插入发送/收到的消息
    @objc fileprivate func insertMsgNote(_ note: Notification) {
        guard let nimMsg = note.object as? NIMMessage else { return }
        // 获取格式化后的模型数据
        let msgs = LXFChatMsgDataHelper.shared.getFormatMsgs(nimMsgs: [nimMsg])
        let models = LXFChatMsgDataHelper.shared.addTimeModel(finalModel: dataArr.last, models: msgs)
        for model in models {
            self.insertRowModel(model: model)
        }
        LXFLog("新消息插入")
    }
    // MARK: 更新消息
    @objc fileprivate func updateMsg(_ note: NSNotification) {
        guard let nimMsg = note.object as? NIMMessage else {
            return
        }
        // 获取格式化后的模型数据
        let msgs = LXFChatMsgDataHelper.shared.getFormatMsgs(nimMsgs: [nimMsg])
        for msg in msgs {
            self.updateRowModel(model: msg)
        }
        LXFLog("更新消息")
    }
    // MARK: 删除消息
    @objc fileprivate func deleteMsg(_ note: NSNotification) {
        guard let nimMsg = note.object as? NIMMessage else { return }
        // 获取格式化后的模型数据
        let msgs = LXFChatMsgDataHelper.shared.getFormatMsgs(nimMsgs: [nimMsg])
        for msg in msgs {
            self.deleteRowModel(model: msg)
        }
        LXFLog("删除重发的消息")
    }
    // MARK: 显示图片
    @objc fileprivate func showImgs(_ note: NSNotification) {
        LXFWeChatTools.shared.searchLocalMsg(userId: user?.userId) { (error, messages) in
            if error != nil {
                LXFLog(error)
                return
            } else {
                DispatchQueue.main.async(execute: { 
                    var imgMsgs = LXFChatMsgDataHelper.shared.getFormatMsgs(nimMsgs: messages)
                    guard let obj = note.object as? [String : Any] else { return }
                    // 当前图片索引
                    var index = 0
                    let model = obj["model"] as! LXFChatMsgModel
                    for imgMsg in imgMsgs {
                        if imgMsg.thumbUrl == model.thumbUrl {
                            break
                        } else {
                            index += 1
                        }
                    }
                    // 防止没有同步到本地导致数组越界
                    if imgMsgs.count == 0 {
                        imgMsgs.append(model)
                    }
                    
                    let indexP = IndexPath(item: index, section: 0)
                    let photoBrowserVC = LXFPhotoBrowserController(indexPath: indexP, msgModels: imgMsgs)
                    let navphotoBrowserVC = LXFBaseNavigationController(rootViewController: photoBrowserVC)
                    navphotoBrowserVC.cc_setZoomTransition(originalView: obj["view"] as! UIImageView)
                    self.present(navphotoBrowserVC, animated: true, completion: nil)
                })
                
            }
        }
    }
    
    // MARK:- 播放视频
    @objc fileprivate func showVideo(_ note: Notification) {
        // 取出本地视频地址
        let model = note.object as? LXFChatMsgModel
        guard model != nil else {
            return
        }
        let videoPlayVC = LXFVideoPlayController(model: model!)
        self.present(videoPlayVC, animated: true, completion: nil)
    }
}
