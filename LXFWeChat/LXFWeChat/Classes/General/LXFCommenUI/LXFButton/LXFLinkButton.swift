//
//  LXFLinkButton.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2016/12/24.
//  Copyright © 2016年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import UIKit

class LXFLinkButton: UIButton {

    init(title: String, fontSize: CGFloat) {
        super.init(frame: CGRect.zero)
        
        let linkColor = RGBA(r: 0.42, g: 0.49, b: 0.62, a: 1.00)
        self.setTitle(title, for: .normal)
        self.setTitleColor(linkColor, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        self.titleLabel?.sizeToFit()
        self.bounds = (self.titleLabel?.bounds)!
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
