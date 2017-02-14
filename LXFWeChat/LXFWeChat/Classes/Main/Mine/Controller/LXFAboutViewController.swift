//
//  LXFAboutViewController.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2017/1/28.
//  Copyright © 2017年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import UIKit

fileprivate let headerHeight: CGFloat = 120.0

class LXFAboutViewController: LXFSettingController {
    
    // MARK:- 懒加载
    lazy var headerView: UIView = {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: headerHeight))
        
        // 文本
        let versionL = UILabel()
        versionL.text = "微信 WeChat 6.5.2"
        versionL.font = UIFont.systemFont(ofSize: 18.0)
        versionL.textColor = UIColor.gray
        versionL.textAlignment = .center
        headerView.addSubview(versionL)
        versionL.snp.makeConstraints({ (make) in
            make.left.right.bottom.equalTo(headerView)
            make.height.equalTo(40)
        })
        
        // 图标
        let iconView = UIImageView(image: #imageLiteral(resourceName: "MoreWeChat"))
        headerView.addSubview(iconView)
        iconView.snp.makeConstraints({ (make) in
            make.bottom.equalTo(versionL.snp.top).offset(8)
            make.centerX.equalTo(headerView.snp.centerX)
            make.width.equalTo(73)
            make.height.equalTo(69)
        })
        
        // 分割线
        let splitLine = UIView()
        headerView.addSubview(splitLine)
        splitLine.backgroundColor = kSplitLineColor
        splitLine.snp.makeConstraints({ (make) in
            make.height.equalTo(0.5)
            make.left.right.bottom.equalTo(headerView)
        })
        
        return headerView
    }()
    
    lazy var powerButton: UIButton = { [unowned self] in
        let powerBtn = LXFLinkButton(title: "微信软件许可及服务协议", fontSize: 12.0)
        powerBtn.addTarget(self, action: #selector(powerBtnClick), for: .touchUpInside)
        return powerBtn
    }()
    
    lazy var powerLabel: UILabel = {
        let powerL = UILabel()
        powerL.text = "腾讯公司 版权所有\nCopyring © 2011-2016 Tencent All Rights Reserved."
        powerL.numberOfLines = 0
        powerL.textColor = UIColor.gray
        powerL.textAlignment = .center
        powerL.font = UIFont.systemFont(ofSize: 12.0)
        powerL.sizeToFit()
        return powerL
    }()
    
    lazy var footerView: UIView = { [unowned self] in
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 0))
        
        // 版权
        footerView.addSubview(self.powerLabel)
        self.powerLabel.snp.makeConstraints({ (make) in
            make.left.right.equalTo(footerView)
            make.bottom.equalTo(footerView).offset(-5)
        })
        footerView.addSubview(self.powerButton)
        self.powerButton.snp.makeConstraints({ (make) in
            make.left.right.equalTo(footerView)
            make.bottom.equalTo(self.powerLabel.snp.top)
        })
        
        return footerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化
        self.setup()
    }
}

// MARK:- 事件处理
extension LXFAboutViewController {
    @objc fileprivate func powerBtnClick() {
        let webView = WKWebViewController()
        webView.loadUrlSting(string: "http://weixin.qq.com/agreement?lang=zh_CN")
        self.pushViewController(webView)
    }
}

// MARK:- 初始化
extension LXFAboutViewController {
    fileprivate func setup() {
        // 设置标题
        navigationItem.title = "关于微信"
        
        // 设置cell的数据
        self.models = LXFUIDataHelper.getAboutVCData()
        
        self.tableView.tableHeaderView = headerView
        footerView.height = kScreenH - headerHeight - 44.0 * CGFloat(self.models.first?.count ?? 0) - 64.0
        self.tableView.tableFooterView = footerView
        // 添加tableView
        view.addSubview(self.tableView)
    }
}

extension LXFAboutViewController {
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00000000001
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
}
