//
//  LXFUserViewController.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2016/12/24.
//  Copyright © 2016年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import UIKit

class LXFUserViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.red
        
        // 初始化
        self.setup()
    }
}

// MARK:- 初始化
extension LXFUserViewController {
    fileprivate func setup() {
        // 添加背景
        view.backgroundColor = UIColor.black
        let bgImgView = UIImageView.init(image: #imageLiteral(resourceName: "LaunchImage"))
        bgImgView.contentMode = .scaleAspectFit
        bgImgView.frame = view.bounds
        view.addSubview(bgImgView)
        
        // 添加按钮
        let margin: CGFloat = 20
        let btnW: CGFloat = (kScreenW - 3.0 * margin) * 0.5
        let btnH: CGFloat = 45
        
        // 登录按钮
        let loginBtn = LXFBarButton(bgColor: kBtnWhite, disabledColor: nil, title: "登录", titleColor: UIColor.black, titleHighlightedColor: UIColor.darkGray)
        loginBtn.addTarget(self, action: #selector(login), for: .touchUpInside)
        view.addSubview(loginBtn)
        loginBtn.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(margin)
            make.width.equalTo(btnW)
            make.height.equalTo(btnH)
            make.bottom.equalTo(view).offset(-margin)
        }
        
        // 注册
        let registerBtn = LXFBarButton(bgColor: kBtnGreen, disabledColor: nil, title: "注册", titleColor: kBtnWhite, titleHighlightedColor: kBtnDisabledWhite)
        registerBtn.addTarget(self, action: #selector(register), for: .touchUpInside)
        view.addSubview(registerBtn)
        registerBtn.snp.makeConstraints { (make) in
            make.right.equalTo(view).offset(-margin)
            make.width.height.bottom.equalTo(loginBtn)
        }
    }
}

// MARK:- 事件处理
extension LXFUserViewController {
    // 登录
    @objc func login() {
        LXFLog("登录")
        let loginVC = LXFLoginController()
        present(loginVC, animated: true, completion: nil)
    }
    
    // 注册
    @objc func register() {
        LXFLog("注册")
        LXFProgressHUD.lxf_showWarning(withStatus: "暂不支持")
    }
}

