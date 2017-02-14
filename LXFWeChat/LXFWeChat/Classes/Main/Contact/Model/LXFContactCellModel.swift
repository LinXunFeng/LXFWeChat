//
//  LXFContactCellModel.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2016/12/28.
//  Copyright © 2016年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import UIKit

class LXFContactCellModel: NSObject {
    // 标题
    var title: String?
    // 拼音
    var pinyin: String?
    // 图标
    var image: UIImage?
    // userId
    var userId: String?
    
    
    override init() {
        super.init()
    }
    
    init(title: String?, image: UIImage?) {
        self.title = title
        self.image = image
        self.pinyin = title?.pinyin()
    }
    
    init(user: NIMUser?) {
        let userInfo = user?.userInfo
        self.title = user?.alias ?? userInfo?.nickName
        self.image = #imageLiteral(resourceName: "Icon")
        self.pinyin = title?.pinyin()
        self.userId = user?.userId
    }
}
