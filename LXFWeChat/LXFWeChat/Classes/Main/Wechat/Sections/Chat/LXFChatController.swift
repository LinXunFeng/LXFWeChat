//
//  LXFChatController.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2016/12/30.
//  Copyright © 2016年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import UIKit
import IQKeyboardManagerSwift

class LXFChatController: LXFBaseController {
    // MARK:- 记录属性
    var finishRecordingVoice: Bool = true   // 决定是否停止录音还是取消录音
    // MARK:- 用户模型
    var user: LXFContactCellModel?
    // MARK:- 懒加载
    // MARK: 输入栏控制器
    lazy var chatBarVC: LXFChatBarViewController = { [unowned self] in
        let barVC = LXFChatBarViewController(user: self.user)
        self.view.addSubview(barVC.view)
        barVC.view.snp.makeConstraints { (make) in
            make.left.right.width.equalTo(self.view)
            make.bottom.equalTo(self.view.snp.bottom)
            make.height.equalTo(kChatBarOriginHeight)
        }
        barVC.delegate = self
        return barVC
    }()
    // MARK: 消息列表控制器
    lazy var chatMsgVC: LXFChatMsgController = { [unowned self] in
        let msgVC = LXFChatMsgController(user: self.user)
        self.view.addSubview(msgVC.view)
        msgVC.view.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self.view)
            make.bottom.equalTo(self.chatBarVC.view.snp.top)
        }
        msgVC.user = self.user
        msgVC.delegate = self
        return msgVC
    }()
    // MARK: 表情面板
    lazy var emotionView: LXFChatEmotionView = { [unowned self] in
        let emotionV = LXFChatEmotionView()
        emotionV.delegate = self.chatBarVC
        return emotionV
    }()
    // MARK: 更多面板
    lazy var moreView: LXFChatMoreView = { [unowned self] in
        let moreV = LXFChatMoreView()
        moreV.delegate = self.chatBarVC
        return moreV
    }()
    // MARK: 录音视图
    lazy var recordVoiceView: LXFChatVoiceView = {
        let recordVoiceV = LXFChatVoiceView()
        recordVoiceV.isHidden = true
        return recordVoiceV
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
        
        IQKeyboardManager.sharedManager().enable = false
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
    }

    override func viewDidDisappear(_ animated: Bool) {
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
    }
}

// MARK:- 初始化
extension LXFChatController {
    fileprivate func setup() {
        // 设置标题
        navigationItem.title = user?.title
        
        // 设置右侧按钮
        createRightBarBtnItem(icon: #imageLiteral(resourceName: "barbuttonicon_InfoSingle"), method: #selector(userInfo))
        
        self.addChildViewController(chatBarVC)
        self.addChildViewController(chatMsgVC)
        
        // 添加表情面板和更多面板
        self.view.addSubview(emotionView)
        self.view.addSubview(moreView)
        self.view.addSubview(recordVoiceView)
        
        // 布局
        emotionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.chatBarVC.view.snp.bottom)
            make.left.right.equalTo(self.view)
            make.height.equalTo(kNoTextKeyboardHeight)
        }
        moreView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.height.equalTo(kNoTextKeyboardHeight)
            make.top.equalTo(self.emotionView.snp.bottom)
        }
        recordVoiceView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top).offset(100)
            make.bottom.equalTo(self.view.snp.bottom).offset(-100)
            make.left.right.equalTo(self.view)
        }
        
        // 注册通知
        self.registerNote()
        LXFWeChatTools.shared.mediaDelegate = self
    }
    // 注册通知
    fileprivate func registerNote() {
        NotificationCenter.default.addObserver(self, selector: #selector(chatBarRecordBtnLongTapBegan(_ :)), name: NSNotification.Name(rawValue: kNoteChatBarRecordBtnLongTapBegan), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(chatBarRecordBtnLongTapChanged(_ :)), name: NSNotification.Name(rawValue: kNoteChatBarRecordBtnLongTapChanged), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(chatBarRecordBtnLongTapEnded(_ :)), name: NSNotification.Name(rawValue: kNoteChatBarRecordBtnLongTapEnded), object: nil)
    }
}

// MARK:- 自身事件处理
extension LXFChatController {
    // MARK: 右上角按钮点击事件
    @objc func userInfo() {
        LXFLog("查看用户信息")
        chatMsgVC.scrollToBottom(animated: true)
    }
    
    // MARK: 重置barView的位置
    func resetChatBarFrame() {
        if chatBarVC.keyboardType == .voice {
            return
        }
        chatBarVC.resetKeyboard()
        UIApplication.shared.keyWindow?.endEditing(true)
        chatBarVC.view.snp.updateConstraints { (make) in
            make.bottom.equalTo(self.view.snp.bottom)
        }
        UIView.animate(withDuration: kKeyboardChangeFrameTime, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    /* ============================== 录音按钮长按事件 ============================== */
    func chatBarRecordBtnLongTapBegan(_ note : Notification) {
        // LXFLog("长按开始")
        finishRecordingVoice = true
        recordVoiceView.recording()
        // 开始录音
        LXFWeChatTools.shared.recordVoice()
    }
    func chatBarRecordBtnLongTapChanged(_ note : Notification) {
        // LXFLog("长按平移")
        let longTap = note.object as! UILongPressGestureRecognizer
        let point = longTap.location(in: self.recordVoiceView)
        if recordVoiceView.point(inside: point, with: nil) {
            recordVoiceView.slideToCancelRecord()
            finishRecordingVoice = false
        } else {
            recordVoiceView.recording()
            finishRecordingVoice = true
        }
    }
    func chatBarRecordBtnLongTapEnded(_ note : Notification) {
        // LXFLog("长按结束")
        if finishRecordingVoice {
            // 停止录音
            LXFWeChatTools.shared.stopRecordVoice()
        } else {
            // 取消录音
            LXFWeChatTools.shared.cancelRecordVoice()
        }
        recordVoiceView.endRecord()
    }
}
