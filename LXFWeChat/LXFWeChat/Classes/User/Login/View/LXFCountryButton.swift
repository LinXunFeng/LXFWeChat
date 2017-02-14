//
//  LXFCountryButton.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2016/12/24.
//  Copyright © 2016年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import UIKit

class LXFCountryButton: UIButton {
    
    let imgW: CGFloat = 10
    
    override func awakeFromNib() {
        self.imageView?.contentMode = .scaleAspectFit
    }
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        return CGRect(x: contentRect.size.width - imgW, y: 0, width: imgW, height: contentRect.size.height)
    }
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        return CGRect(x: 0, y: 0, width: contentRect.size.width - imgW, height: contentRect.size.height)
    }

}
