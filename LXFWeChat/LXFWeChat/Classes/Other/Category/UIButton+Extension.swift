//
//  UIButton+Extension.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2016/12/24.
//  Copyright © 2016年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import Foundation

extension UIButton {
    class func btn(bgColor: UIColor, disabledColor: UIColor, title: String, titleColor: UIColor) -> UIButton {
        
        let btn = UIButton(type: .custom)
        btn.setTitleColor(titleColor, for: .normal)
        btn.backgroundColor = bgColor
        btn.layer.cornerRadius = 3.0
        btn.layer.masksToBounds = true
        
        return btn
    }
}

