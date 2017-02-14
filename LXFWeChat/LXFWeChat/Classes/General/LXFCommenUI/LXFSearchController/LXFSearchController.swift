//
//  LXFSearchController.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2016/12/27.
//  Copyright © 2016年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import UIKit

fileprivate let kLXFSearchTintColor = RGBA(r: 0.12, g: 0.74, b: 0.13, a: 1.00)

class LXFSearchController: UISearchController {
    
    lazy var hasFindCancelBtn: Bool = {
        return false
    }()
    lazy var link: CADisplayLink = {
        CADisplayLink(target: self, selector: #selector(findCancel))
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override init(searchResultsController: UIViewController?) {
        super.init(searchResultsController: searchResultsController)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        searchBar.barTintColor = kSectionColor

        // 搜索框
        searchBar.barStyle = .default
        searchBar.tintColor = kLXFSearchTintColor
        // 去除上下两条横线
        searchBar.setBackgroundImage(kSectionColor.trans2Image(), for: .any, barMetrics: .default)
        // 右侧语音
        searchBar.showsBookmarkButton = true
        searchBar.setImage(#imageLiteral(resourceName: "VoiceSearchStartBtn"), for: .bookmark, state: .normal)
        
        searchBar.delegate = self
        
    }
    
    func findCancel() {
        let btn = searchBar.value(forKey: "_cancelButton") as AnyObject
        if btn.isKind(of: NSClassFromString("UINavigationButton")!) {
            LXFLog("就是它")
            link.invalidate()
            link.remove(from: RunLoop.current, forMode: .commonModes)
            hasFindCancelBtn = true
            let cancel = btn as! UIButton
            cancel.setTitleColor(kLXFSearchTintColor, for: .normal)
            // cancel.setTitleColor(UIColor.orange, for: .highlighted)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 设置状态栏颜色
        UIApplication.shared.statusBarStyle = .default
    }
}

extension LXFSearchController: UISearchBarDelegate {
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        LXFLog("点击了语音按钮")
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        if !hasFindCancelBtn {
            link.add(to: RunLoop.current, forMode: .commonModes)
        }
    }
}
