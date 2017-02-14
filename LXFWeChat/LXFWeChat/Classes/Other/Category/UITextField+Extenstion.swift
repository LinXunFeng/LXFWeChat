//
//  UITextField+Extenstion.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2017/2/8.
//  Copyright © 2017年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import Foundation

enum UITextFieldPaddingDirection {
    case left
    case right
}

extension UITextField {
    func setPadding(with width: CGFloat, direction: UITextFieldPaddingDirection) {
        let frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        let paddingView = UIView(frame: frame)
        switch direction {
        case .left:
            self.leftViewMode = .always
            self.leftView = paddingView
        default:
            self.rightViewMode = .always
            self.rightView = paddingView
        }
        
    }
}
