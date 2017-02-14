//
//  Common.swift
//  CustomPrintln
//
//  Created by LXF on 2016/11/7.
//  Copyright © 2016年 LXF. All rights reserved.
//

import UIKit
import SnapKit
import SwiftyJSON
import Toast_Swift
import IQKeyboardManagerSwift
import Kingfisher
import SwiftDate

// 屏幕宽度
let kScreenH = UIScreen.main.bounds.height
// 屏幕高度
let kScreenW = UIScreen.main.bounds.width
// tabBar高度
let kTabBarH: CGFloat = 49.0

// MARK:- 颜色方法
func normalRGBA (r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) -> UIColor {
    return UIColor (red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}
func RGBA (r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) -> UIColor {
    return UIColor (red: r, green: g, blue: b, alpha: a)
}

// MARK:- 常用按钮颜色
let kBtnWhite = RGBA(r: 0.97, g: 0.97, b: 0.97, a: 1.00)
let kBtnDisabledWhite = RGBA(r: 0.97, g: 0.97, b: 0.97, a: 0.30)
let kBtnGreen = RGBA(r: 0.15, g: 0.67, b: 0.16, a: 1.00)
let kBtnDisabledGreen = RGBA(r: 0.65, g: 0.87, b: 0.65, a: 1.00)
let kBtnRed = RGBA(r: 0.89, g: 0.27, b: 0.27, a: 1.00)
// 分割线颜色
let kSplitLineColor = RGBA(r: 0.78, g: 0.78, b: 0.80, a: 1.00)
// 常规背景颜色
let kCommonBgColor = RGBA(r: 0.92, g: 0.92, b: 0.92, a: 1.00)
let kSectionColor = RGBA(r: 0.94, g: 0.94, b: 0.96, a: 1.00)
// 导航栏背景颜色
let kNavBarBgColor = normalRGBA(r: 20, g: 20, b: 20, a: 0.9)

// 表情键盘颜色大全
let kChatBoxColor = normalRGBA(r: 244.0, g: 244.0, b: 246.0, a: 1.0)
let kLineGrayColor = normalRGBA(r: 188.0, g: 188.0, b: 188.0, a: 0.6)


// MARK:- 自定义打印方法
func LXFLog<T>(_ message : T, file : String = #file, funcName : String = #function, lineNum : Int = #line) {
    
    #if DEBUG
        
        let fileName = (file as NSString).lastPathComponent
        
        print("\(fileName):(\(lineNum))-\(message)")
        
    #endif
}


// MARK:- 通知常量
// 通讯录好友发生变化
let kNoteContactUpdateFriends  = "noteContactUpdateFriends"
// 添加消息
let kNoteChatMsgInsertMsg    = "noteChatMsgInsertMsg"
// 更新消息状态
let kNoteChatMsgUpdateMsg = "noteChatMsgUpdateMsg"
// 重发消息状态
let kNoteChatMsgResendMsg = "noteChatMsgResendMsg"
// 点击消息中的图片
let kNoteChatMsgTapImg = "noteChatMsgTapImg"
// 音频播放完毕
let kNoteChatMsgAudioPlayEnd = "noteChatMsgAudioPlayEnd"
// 视频开始播放
let kNoteChatMsgVideoPlayStart = "noteChatMsgVideoPlayStart"
/* ============================== 录音按钮长按事件 ============================== */
let kNoteChatBarRecordBtnLongTapBegan = "noteChatBarRecordBtnLongTapBegan"
let kNoteChatBarRecordBtnLongTapChanged = "noteChatBarRecordBtnLongTapChanged"
let kNoteChatBarRecordBtnLongTapEnded = "noteChatBarRecordBtnLongTapEnded"
/* ============================== 与网络交互后返回 ============================== */
let kNoteWeChatGoBack = "noteWeChatGoBack"

// MARK:- SDK
let kAppKey = "8c05fc8cf099c153dcb5f2daec46821d"
