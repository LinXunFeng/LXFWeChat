//
//  LXFChatEmotion.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2017/1/1.
//  Copyright © 2017年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import UIKit

class LXFChatEmotion: NSObject {
    // MARK:- 定义属性
    var image: String? {   // 表情对应的图片名称
        didSet {
            imgPath = Bundle.main.bundlePath + "/Expression.bundle/" + image! + ".png"
        }
    }
    var text: String?     // 表情对应的文字
    
    // MARK:- 数据处理
    var imgPath: String?
    var isRemove: Bool = false
    var isEmpty: Bool = false
    
    override init() {
        super.init()
    }
    
    convenience init(dict: [String : String]) {
        self.init()
        setValuesForKeys(dict)
    }
    
    init(isRemove: Bool) {
        self.isRemove = (isRemove)
    }
    init(isEmpty: Bool) {
        self.isEmpty = (isEmpty)
    }
}
