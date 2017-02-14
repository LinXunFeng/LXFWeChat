//
//  LXFChatBarViewController.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2016/12/31.
//  Copyright © 2016年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import UIKit

let kKeyboardChangeFrameTime: TimeInterval = 0.25
let kNoTextKeyboardHeight: CGFloat = 216.0

protocol LXFChatBarViewControllerDelegate : NSObjectProtocol {
    /* ============================= barView =============================== */
    func chatBarShowTextKeyboard()
    func chatBarShowVoice()
    func chatBarShowEmotionKeyboard()
    func chatBarShowMoreKeyboard()
    func chatBarUpdateHeight(height: CGFloat)
    func chatBarVC(chatBarVC: LXFChatBarViewController, didChageChatBoxBottomDistance distance: CGFloat)
}

class LXFChatBarViewController: UIViewController {
    // MARK:- 用户模型
    var user: LXFContactCellModel?
    // MARK:- 记录属性
    var keyboardFrame: CGRect?
    var keyboardType: LXFChatKeyboardType?
    
    // MARK:- 代理
    weak var delegate: LXFChatBarViewControllerDelegate?
    
    // MARK:- 懒加载
    lazy var barView : LXFChatBarView = { [unowned self] in
        let barView = LXFChatBarView()
        barView.delegate = self
        return barView
    }()
    
    lazy var imgPickerVC: TZImagePickerController = { [unowned self] in
        return TZImagePickerController(maxImagesCount: 9, columnNumber: 4, delegate: self)
    }()
    lazy var videoVC: KZVideoViewController = { [unowned self] in
        let videoVC = KZVideoViewController()
        videoVC.delegate = self
        // videoVC.startAnimation(with: .small)
        return videoVC
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
        
        view.addSubview(barView)
        barView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view)
            make.height.equalTo(50)
        }
        
        // 监听键盘
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameWillChange(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
}

// MARK:- 键盘监听事件
extension LXFChatBarViewController {
    @objc fileprivate func keyboardWillHide(_ note: NSNotification) {
        keyboardFrame = CGRect.zero
        if barView.keyboardType == .emotion || barView.keyboardType == .more {
            return
        }
        delegate?.chatBarVC(chatBarVC: self, didChageChatBoxBottomDistance: 0)
    }
    
    @objc fileprivate func keyboardFrameWillChange(_ note: NSNotification) {
        keyboardFrame = note.userInfo?[UIKeyboardFrameEndUserInfoKey] as! CGRect?
        
        LXFLog(keyboardFrame)
        
        if barView.keyboardType == .emotion || barView.keyboardType == .more {
            return
        }
        delegate?.chatBarVC(chatBarVC: self, didChageChatBoxBottomDistance: keyboardFrame?.height ?? 0)
    }
}

// MARK:- 对外提供的方法
extension LXFChatBarViewController {
    func resetKeyboard() {
        barView.resetBtnsUI()
        barView.keyboardType = .noting
    }
}

// MARK:- 发送信息
extension LXFChatBarViewController {
    func sendMessage() {
        
        // 取出字符串
        let message = barView.inputTextView.getEmotionString()
        barView.inputTextView.text = ""
        
        // 发送
        LXFWeChatTools.shared.sendText(userId: user?.userId, text: message)
        LXFLog(message)
    }
}
