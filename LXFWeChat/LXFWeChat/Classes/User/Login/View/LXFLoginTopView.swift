//
//  LXFLoginTopView.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2016/12/24.
//  Copyright © 2016年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import UIKit

class LXFLoginTopView: UIView {
    
    // MARK:- 属性
    // MARK: 记录属性
    // MARK: 回调属性
    var cancelBlock: (() -> ())?
    var loginBtnBlock: ((_ canLogin: Bool) -> ())?
    // MARK: 拖线属性
    @IBOutlet weak var phoneF: UITextField!
    @IBOutlet weak var pwdF: UITextField!
    
    // MARK:- 自定义属性
    var phoneLength: Int = 0
    var pwdLength: Int = 0
    
    class func newInstance() -> LXFLoginTopView? {
        let nibView = Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)
        if let view = nibView?.first as? LXFLoginTopView {
            return view
        }
        return nil
        
    }
    
    // MARK:- 拖线事件
    @IBAction func cancel() {
        if self.cancelBlock != nil {
            self.cancelBlock!()
        }
    }
}

extension LXFLoginTopView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if self.loginBtnBlock == nil {
            return true
        }
        
        let strLength = (textField.text?.lengthOfBytes(using: String.Encoding.utf8))! - range.length + string.lengthOfBytes(using: String.Encoding.utf8)
        
        if textField == self.phoneF {
            self.phoneLength = strLength
        } else if textField == self.pwdF {
            self.pwdLength = strLength
        }
        
        if phoneLength > 0 && pwdLength > 0 {
            // LXFLog("都大于0")
            self.loginBtnBlock!(true)
        } else {
            // LXFLog("不大于0")
            self.loginBtnBlock!(false)
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        LXFLog(textField.text?.lengthOfBytes(using: String.Encoding.utf8))
    }
}


