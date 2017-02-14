//
//  LXFNickNameViewController.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2017/2/8.
//  Copyright © 2017年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import UIKit

class LXFNickNameViewController: LXFBaseController {
    
    // MARK:- 懒加载
    lazy var nameField: UITextField = {
        let nameF = UITextField(frame: CGRect(x: 0, y: 64 + 15, width: kScreenW, height: 40))
        nameF.setPadding(with: 10, direction: .left)
        nameF.text = LXFWeChatTools.shared.getMineInfo()?.userInfo?.nickName
        nameF.clearButtonMode = .whileEditing
        nameF.font = UIFont.systemFont(ofSize: 15.0)
        nameF.background = UIColor.white.trans2Image()
        return nameF
    }()

    // MARK:- 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化
        self.setup()
    }
}

// MARK:- 初始化
extension LXFNickNameViewController {
    func setup() {
        // 设置标题
        navigationItem.title = "名字"
        
        // 设置barBtnItem
        self.createRightBarBtnItem(title: "保存", method: #selector(save))
        self.createLeftBarBtnItem(title: "取消", method: nil)
        
        view.addSubview(nameField)
        nameField.becomeFirstResponder()
    }
}

extension LXFNickNameViewController {
    @objc func save() {
        LXFLog("保存")
    }
}
