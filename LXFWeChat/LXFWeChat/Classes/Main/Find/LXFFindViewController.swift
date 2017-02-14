//
//  LXFFindViewController.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2016/12/24.
//  Copyright © 2016年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import UIKit

fileprivate let headerH: CGFloat = 22.0
fileprivate let cellH: CGFloat = 44.0

class LXFFindViewController: LXFSettingController {
    
    // MARK:- 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化
        self.setup()
    }
}

extension LXFFindViewController {
    fileprivate func setup() {
        // 设置标题
        navigationItem.title = "发现"
        
        // 设置cell的数据   
        self.models = LXFUIDataHelper.getFindVCData()
        
        // 添加tableView
        view.addSubview(self.tableView)
    }
}

// MARK:- UITableViewDelegate
extension LXFFindViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        
        if indexPath.section == 3 && indexPath.row == 0 {   // 购物
            let webView = WKWebViewController()
            webView.loadUrlSting(string: "https://www.baidu.com")
            webView.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(webView, animated: true)
        } else {
            let urlStr = "https://www.baidu.com/img/bd_logo1.png"
            
            LXFNetworkTools.shared.download(urlStr: urlStr, savePath: "/Users/lxf/Desktop/x.png", progress: { (progress) in
                LXFLog("进度 --- \(progress)")
            }, resultBlock: { (url, error) in
                LXFLog("url --- \(url) \t error --- \(error)")
            })
            
//            LXFNetworkTools.shared.download(urlStr: urlStr, savePath: "/Users/lxf/Desktop/x.png", progress: nil, resultBlock: nil)
        }
        
    }
}
