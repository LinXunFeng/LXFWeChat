//
//  LXFSettingCellModel.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2017/1/26.
//  Copyright © 2017年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import UIKit

enum LXFSettingCellType {
    case `default`
    case check
    case `switch`
    case middle
    case avatar
}

class LXFSettingCellModel: NSObject {
    // 图标
    var icon: UIImage?
    // 标题
    var title: String?
    // 副标题
    var subTitle: String?
    // 提示图
    var tipImg: String?
    // 提示语
    var tipTitle: String?
    // 类型
    var type: LXFSettingCellType!
    
    override init() {
        super.init()
    }
    
    init(icon: UIImage?, title: String?, tipImg: String? = nil, tipTitle: String? = nil, type: LXFSettingCellType = .default) {
        self.icon = icon
        self.title = title
        self.tipImg = tipImg
        self.tipTitle = tipTitle
        self.type = type
    }
}
