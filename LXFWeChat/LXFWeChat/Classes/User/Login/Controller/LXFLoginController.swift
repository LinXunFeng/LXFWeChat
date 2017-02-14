//
//  LXFLoginController.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2016/12/24.
//  Copyright © 2016年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import UIKit

class LXFLoginController: UIViewController {
    
    // 顶部的view
    lazy var topView: LXFLoginTopView = {
        guard let topView = LXFLoginTopView.newInstance() else {
            return LXFLoginTopView()
        }
        topView.cancelBlock = { [unowned self] in
            self.dismiss(animated: true, completion: nil)
        }
        return topView
    }()

    // MARK:- 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化
        self.setup()
    }
}

// MARK:- 初始化
extension LXFLoginController {
    func setup() {
        // 设置背景颜色
        view.backgroundColor = UIColor.white
        
        // 顶部的view
        topView.frame = CGRect(x: 0, y: 0, width: kScreenW, height: 300)
        view.addSubview(topView)
        
        let margin: CGFloat = 20.0
        // 登录
        let loginBtn = LXFBarButton(bgColor: kBtnGreen, disabledColor: kBtnDisabledGreen, title: "登录", titleColor: kBtnWhite, titleHighlightedColor: kBtnDisabledWhite)
        loginBtn.isEnabled = false
        view.addSubview(loginBtn)
        loginBtn.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom).offset(margin * 0.5)
            make.left.equalTo(self.view).offset(margin)
            make.right.equalTo(self.view).offset(-margin)
            make.height.equalTo(48)
        }
        loginBtn.addTarget(self, action: #selector(login), for: .touchUpInside)
        
        // 设置登录按钮状态的回调
        topView.loginBtnBlock = {
            loginBtn.isEnabled = $0
        }
        
        // 短信验证码登录
        let smsLoginBtn = LXFLinkButton(title: "通过短信验证码登录", fontSize: 13)
        view.addSubview(smsLoginBtn)
        smsLoginBtn.snp.makeConstraints { (make) in
            make.top.equalTo(loginBtn.snp.bottom).offset(margin * 0.7)
            make.centerX.equalTo(self.view)
        }
        smsLoginBtn.addTarget(self, action: #selector(smsLogin), for: .touchUpInside)
        
        // 中间分割线
        let splitLine = UIView()
        splitLine.backgroundColor = kSplitLineColor
        view.addSubview(splitLine)
        splitLine.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            make.width.equalTo(1)
            make.bottom.equalTo(self.view.snp.bottom).offset(-margin * 1.5)
            make.centerX.equalTo(self.view.snp.centerX)
        }
        
        // 登录遇到问题
        let matterLoginBtn = LXFLinkButton(title: "登录遇到问题?", fontSize: 15)
        view.addSubview(matterLoginBtn)
        matterLoginBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(splitLine.snp.centerY)
            make.right.equalTo(splitLine.snp.left).offset(-margin)
        }
        matterLoginBtn.addTarget(self, action: #selector(matterLogin), for: .touchUpInside)
        
        // 其他方法登录
        let otherLoginBtn = LXFLinkButton(title: "其他方法登录", fontSize: 15)
        view.addSubview(otherLoginBtn)
        otherLoginBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(splitLine.snp.centerY)
            make.left.equalTo(splitLine.snp.right).offset(margin)
        }
        otherLoginBtn.addTarget(self, action: #selector(otherLogin), for: .touchUpInside)
    }
}

// MARK:- 事件处理
extension LXFLoginController {
    @objc func login() {
        LXFLog("登录")
        
        guard let account = topView.phoneF.text, let pwd = topView.pwdF.text else {
            return
        }
        
        // 注销第一响应者
        self.topView.phoneF.resignFirstResponder()
        self.topView.pwdF.resignFirstResponder()
        
        LXFProgressHUD.lxf_showWithStatus("正在登录")
        LXFWeChatTools.shared.login(with: account, pwd: pwd, errorBlock: { (error) in
            LXFProgressHUD.lxf_dismiss()
            if error != nil {   // 登录失败
                LXFLog("错误码: \(error)")
                LXFLog((error as! NSError).code)
            } else {    // 登录成功
                // 跳转到主页
                UIApplication.shared.keyWindow?.rootViewController = LXFMainViewController()
            }
        })
    }
    @objc func smsLogin() {
        LXFLog("短信验证码登录")
    }
    @objc func matterLogin() {
        LXFLog("登录遇到问题")
    }
    @objc func otherLogin() {
        LXFLog("其他方法登录")
    }
}
