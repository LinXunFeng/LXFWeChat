//
//  LXFProgressHUD.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2017/1/15.
//  Copyright © 2017年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import UIKit
import SVProgressHUD

fileprivate enum HUDType: Int {
    case success
    case errorObject
    case errorString
    case info
    case loading
}

class LXFProgressHUD: NSObject {
    class func lxf_initHUD() {
        SVProgressHUD.setBackgroundColor(UIColor ( red: 0.0, green: 0.0, blue: 0.0, alpha: 0.7 ))
        SVProgressHUD.setForegroundColor(UIColor.white)
        SVProgressHUD.setFont(UIFont.systemFont(ofSize: 14))
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.none)
    }
    
    //成功
    class func lxf_showSuccess(withStatus string: String?) {
        self.LXFProgressHUDShow(.success, status: string)
    }
    
    //失败 ，NSError
    class func lxf_showError(withObject error: NSError) {
        self.LXFProgressHUDShow(.errorObject, status: nil, error: error)
    }
    
    //失败，String
    class func lxf_showError(withStatus string: String?) {
        self.LXFProgressHUDShow(.errorString, status: string)
    }
    
    //转菊花
    class func lxf_showWithStatus(_ string: String?) {
        self.LXFProgressHUDShow(.loading, status: string)
    }
    
    //警告
    class func lxf_showWarning(withStatus string: String?) {
        self.LXFProgressHUDShow(.info, status: string)
    }
    
    //dismiss消失
    class func lxf_dismiss() {
        SVProgressHUD.dismiss()
    }
    
    //私有方法
    fileprivate class func LXFProgressHUDShow(_ type: HUDType, status: String? = nil, error: NSError? = nil) {
        SVProgressHUD.setDefaultMaskType(.none)
        switch type {
        case .success:
            SVProgressHUD.showSuccess(withStatus: status)
            break
        case .errorObject:
            guard let newError = error else {
                SVProgressHUD.showError(withStatus: "Error:出错拉")
                return
            }
            
            if newError.localizedFailureReason == nil {
                SVProgressHUD.showError(withStatus: "Error:出错拉")
            } else {
                SVProgressHUD.showError(withStatus: error!.localizedFailureReason)
            }
            break
        case .errorString:
            SVProgressHUD.showError(withStatus: status)
            break
        case .info:
            SVProgressHUD.showInfo(withStatus: status)
            break
        case .loading:
            SVProgressHUD.setDefaultMaskType(.clear)
            SVProgressHUD.show(withStatus: status)
            break
        }
    }
    
}
