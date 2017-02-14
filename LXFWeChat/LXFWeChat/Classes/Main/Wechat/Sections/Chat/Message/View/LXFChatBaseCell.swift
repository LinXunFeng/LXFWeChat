//
//  LXFChatBaseCell.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2017/1/3.
//  Copyright © 2017年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import UIKit

class LXFChatBaseCell: UITableViewCell {
    
    // MARK:- 模型
    var model: LXFChatMsgModel? {
        didSet {
            baseCellSetModel()
        }
    }
    
    lazy var avatar: UIButton = {
        let avaBtn = UIButton()
        avaBtn.setImage(#imageLiteral(resourceName: "Icon"), for: .normal)
        return avaBtn
    }()
    lazy var bubbleView: UIImageView = {
        return UIImageView()
    }()
    
    lazy var tipView: UIView = { [unowned self] in
        let tipV = UIView()
        tipV.addSubview(self.activityIndicator)
        tipV.addSubview(self.resendButton)
        return tipV
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let act = UIActivityIndicatorView()
        act.activityIndicatorViewStyle = .gray
        act.hidesWhenStopped = false
        act.startAnimating()
        return act
    }()
    
    lazy var resendButton: UIButton = {
        let resendBtn = UIButton(type: .custom)
        resendBtn.setImage(#imageLiteral(resourceName: "resend"), for: .normal)
        resendBtn.contentMode = .scaleAspectFit
        resendBtn.addTarget(self, action: #selector(resend), for: .touchUpInside)
        return resendBtn
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        self.addSubview(avatar)
        self.addSubview(bubbleView)
        self.addSubview(tipView)
        
        activityIndicator.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalTo(tipView)
        }
        resendButton.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalTo(tipView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LXFChatBaseCell {
    func baseCellSetModel() {
        tipView.isHidden = false
        activityIndicator.startAnimating()
        guard let deliveryState = model?.message?.deliveryState else {
            return
        }
        if model?.userType == .me { // 自己
            switch deliveryState {
            case .delivering:
                resendButton.isHidden = true
                activityIndicator.isHidden = false
            case .failed:
                resendButton.isHidden = false
                activityIndicator.isHidden = true
            case .deliveried:
                tipView.isHidden = true
            }
        } else {    // 对方
            tipView.isHidden = true
        }
    }
}

extension LXFChatBaseCell {
    // MARK:- 获取cell的高度
    func getCellHeight() -> CGFloat {
        self.layoutSubviews()
        
        if avatar.height > bubbleView.height {
            return avatar.height + 10.0
        } else {
            return bubbleView.height + 10.0
        }
    }
    
    @objc func resend() {
        LXFLog("重新发送操作")
        guard let message = model?.message else {
            return
        }
        if LXFWeChatTools.shared.resendMessage(message: message) {
            LXFLog("重送发送成功")
        } else {
            LXFLog("重送发送成失败")
        }
    }
}
