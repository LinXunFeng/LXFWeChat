//
//  LXFVideoChatController.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2017/7/23.
//  Copyright © 2017年 林洵锋. All rights reserved.
//

import UIKit
import LFLiveKit
import IJKMediaFramework

class LXFVideoChatController: UIViewController {
    
    fileprivate var user: LXFContactCellModel?  // 对方的user
    fileprivate var isInitiator: Bool   // 是否为发起者
    fileprivate var isBackCamera: Bool = false
    fileprivate var toHidden: Bool = false
    fileprivate var topView: LXFVideoChatTopView?
    var ijkPlayer: IJKFFMoviePlayerController?
    
    fileprivate var isChating: Bool = false { didSet { setIsChating() } }
    
    fileprivate lazy var session: LFLiveSession = {
        let audioConfiguration = LFLiveAudioConfiguration.default()
        let videoConfiguration = LFLiveVideoConfiguration.defaultConfiguration(for: .low2, outputImageOrientation: .portrait)
        let session = LFLiveSession(audioConfiguration: audioConfiguration, videoConfiguration: videoConfiguration)
//        session?.delegate = self
//        session?.preView = self.myCameraView
        session?.preView = self.myCameraView
        return session!
    }()
    
    fileprivate lazy var cancelBtn: LXFVerticalBtn = { [unowned self] in
        let btn = LXFVerticalBtn()
        btn.setImage(#imageLiteral(resourceName: "callDeclineBtn"), for: .normal)
        btn.setImage(#imageLiteral(resourceName: "callDeclineBtnHL"), for: .highlighted)
        btn.setTitle("挂断", for: .normal)
        btn.addTarget(self, action: #selector(cancelChat), for: .touchUpInside)
        self.view.addSubview(btn)
        return btn
    }()
    
    fileprivate lazy var answerBtn: LXFVerticalBtn = { [unowned self] in
        let btn = LXFVerticalBtn()
        btn.setImage(#imageLiteral(resourceName: "callAnswerBtn"), for: .normal)
        btn.setImage(#imageLiteral(resourceName: "callAnswerBtnHL"), for: .highlighted)
        btn.setTitle("接听", for: .normal)
        btn.addTarget(self, action: #selector(answerChat), for: .touchUpInside)
        self.view.addSubview(btn)
        return btn
        }()
    
    lazy var myCameraView: UIView = { [unowned self] in
        let view = UIView()
        view.backgroundColor = UIColor.black
//        let width: CGFloat = 160
//        let height: CGFloat = kScreenH * width / kScreenW
//        let x: CGFloat = kScreenW - 8 - width
//        view.frame = CGRect(x: x, y: 20, width: width, height: height)
        view.frame = self.view.bounds
        self.view.addSubview(view)
        return view
    }()
    
    init(user: LXFContactCellModel?, isInitiator: Bool) {
        self.user = user
        self.isInitiator = isInitiator
        self.isChating = self.isInitiator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        sendMessage()
    }
}

extension LXFVideoChatController {
    fileprivate func setupUI() {
        view.backgroundColor = UIColor.black
        myCameraView.sendSubview(toBack: view)
        
        cancelBtn.snp.makeConstraints { (make) in
            make.width.equalTo(75)
            make.height.equalTo(105)
            make.bottom.equalTo(view.snp.bottom).offset(-30)
            if (isInitiator) {
                make.centerX.equalTo(self.view.snp.centerX)
            } else {
                make.centerX.equalTo(self.view.snp.centerX).multipliedBy(0.5)
            }
        }
        
        
        if !isInitiator {
            answerBtn.snp.makeConstraints({ (make) in
                make.width.equalTo(75)
                make.height.equalTo(105)
                make.bottom.equalTo(view.snp.bottom).offset(-30)
                make.centerX.equalTo(self.view.snp.centerX).offset(kScreenW * 0.25)
            })
        }
        
        let topView = LXFVideoChatTopView(imageUrl: nil, userName: user?.title ?? "")
        self.topView = topView
        topView.frame = CGRect(x: 0, y: 30, width: kScreenW, height: 80)
        view.addSubview(topView)
        
        // 推流与拉流
        isInitiator ? pushStream(session) : pullStream(user)
    }
    
    fileprivate func sendMessage() {
        if !self.isInitiator {return}
        LXFLog("xxx")
        LXFWeChatTools.shared.sendVideoChat(userId: user?.userId)
    }
}

extension LXFVideoChatController {
    @objc fileprivate func cancelChat() {
        self.session.running = false
        dismiss(animated: true, completion: nil)
        LXFLog("挂断")
    }
    
    @objc fileprivate func answerChat() {
        isChating = true
        LXFLog("接听")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (!isChating) { return }
        self.toHidden = !self.toHidden
        self.topView?.isHidden = self.toHidden
        self.cancelBtn.isHidden = self.toHidden
        self.answerBtn.isHidden = self.toHidden
    }
    
    fileprivate func setIsChating() {
        self.answerBtn.isEnabled = false
        
        ijkPlayer?.prepareToPlay()
        
        
    }
}
