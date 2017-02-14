//
//  LXFChatMsgModel.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2017/1/4.
//  Copyright © 2017年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import UIKit

enum LXFChatMsgUserType: Int {
    case me
    case friend
}

enum LXFChatMsgModelType: Int {
    case text
    case image
    case time
    case audio
    case video
}

class LXFChatMsgModel: NSObject {
    var cellHeight: CGFloat = 0
    // 会话类型
    var modelType: LXFChatMsgModelType = .text
    // 会话来源
    var userType: LXFChatMsgUserType = .me
    
    var message: NIMMessage? {
        didSet {
            guard let message = message else {
                return
            }
            self.fromUserId = message.from
            self.sessionId = message.session?.sessionId
            self.messageId = message.messageId
            self.text = message.text
            self.time = message.timestamp
            switch message.messageType {
            case .text:
                modelType = .text
            case .image:
                modelType = .image
                let imgObj = message.messageObject as! NIMImageObject
                thumbPath = imgObj.thumbPath
                thumbUrl = imgObj.thumbUrl
                imgPath = imgObj.path
                imgUrl = imgObj.url
                imgSize = imgObj.size
                fileLength = imgObj.fileLength
            case .audio:
                modelType = .audio
                let audioObj = message.messageObject as! NIMAudioObject
                audioPath = audioObj.path
                audioUrl = audioObj.url
                audioDuration = CGFloat(audioObj.duration) / 1000.0
            case .video:
                modelType = .video
                let videoObj = message.messageObject as! NIMVideoObject
                videoDisplayName = videoObj.displayName
                videoPath = videoObj.path
                videoUrl = videoObj.url
                videoCoverUrl = videoObj.coverUrl
                videoCoverPath = videoObj.coverPath
                videoCoverSize = videoObj.coverSize
                videoDuration = videoObj.duration
                fileLength = videoObj.fileLength
            default:
                break
            }
            
            userType = message.from ?? "" == LXFWeChatTools.shared.getCurrentUserId() ? .me : .friend
        }
    }
    
    // 信息来源id
    var fromUserId: String?
    // 会话id(即当前聊天的userId)
    var sessionId: String?
    // 信息id
    var messageId: String?
    // 附件
    var messageObject: Any?
    // 信息时间辍
    var time: TimeInterval?
    var timeStr: String?
    
    /* ============================== 文字 ============================== */
    // 文字
    var text: String?
    /* ============================== 图片 ============================== */
    // 本地原图地址
    var imgPath: String?
    // 云信原图地址
    var imgUrl: String?
    // 本地缩略图地址
    var thumbPath: String?
    // 云信缩略图地址
    var thumbUrl: String?
    // 图片size
    var imgSize: CGSize?
    // 文件大小
    var fileLength: Int64?
    /* ============================== 语音 ============================== */
    // 语音的本地路径
    var audioPath: String?
    // 语音的远程路径
    var audioUrl: String?
    // 语音时长，毫秒为单位
    var audioDuration: CGFloat = 0
    /* ============================== 视频 ============================== */
    // 视频展示名
    var videoDisplayName: String?
    // 视频的本地路径
    var videoPath: String?
    // 视频的远程路径
    var videoUrl: String?
    // 视频封面的远程路径
    var videoCoverUrl : String?
    // 视频封面的本地路径
    var videoCoverPath : String?
    // 封面尺寸
    var videoCoverSize: CGSize?
    // 视频时长，毫秒为单位
    var videoDuration: Int?
    
    
    
    override init() {
        super.init()
    }
}

/*
 message.deliveryState
 /**
 *  消息发送失败
 */
 NIMMessageDeliveryStateFailed,
 /**
 *  消息发送中
 */
 NIMMessageDeliveryStateDelivering,
 /**
 *  消息发送成功
 */
 NIMMessageDeliveryStateDeliveried
 */

/* ============================================================ */

/*
 message.messageType
 /**
 *  文本类型消息
 */
 NIMMessageTypeText          = 0,
 /**
 *  图片类型消息
 */
 NIMMessageTypeImage         = 1,
 /**
 *  声音类型消息
 */
 NIMMessageTypeAudio         = 2,
 /**
 *  视频类型消息
 */
 NIMMessageTypeVideo         = 3,
 /**
 *  位置类型消息
 */
 NIMMessageTypeLocation      = 4,
 /**
 *  通知类型消息
 */
 NIMMessageTypeNotification  = 5,
 /**
 *  文件类型消息
 */
 NIMMessageTypeFile          = 6,
 /**
 *  提醒类型消息
 */
 NIMMessageTypeTip           = 10,
 /**
 *  自定义类型消息
 */
 NIMMessageTypeCustom        = 100
 */
