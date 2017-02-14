//
//  LXFUIDataHelper.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2016/12/29.
//  Copyright © 2016年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import UIKit

class LXFUIDataHelper: NSObject {
    
    // MARK:- 通讯录
    class func getContactFuncs() -> [LXFContactCellModel] {
        return [
            LXFContactCellModel(title: "新的朋友", image: #imageLiteral(resourceName: "plugins_FriendNotify")),
            LXFContactCellModel(title: "群聊", image: #imageLiteral(resourceName: "add_friend_icon_addgroup")),
            LXFContactCellModel(title: "标签", image: #imageLiteral(resourceName: "Contact_icon_ContactTag")),
            LXFContactCellModel(title: "公众号", image: #imageLiteral(resourceName: "add_friend_icon_offical"))
        ]
    }
    
    // MARK:- 发现
    class func getFindVC(items: @escaping (_ icons: [[UIImage]], _ titles: [[String]])->Void) {
        // cell图标数组
        let mineCellIcons: [[UIImage]] = [
            [#imageLiteral(resourceName: "ff_IconShowAlbum")],
            [#imageLiteral(resourceName: "ff_IconQRCode"), #imageLiteral(resourceName: "ff_IconShake")],
            [#imageLiteral(resourceName: "ff_IconLocationService")],
            [#imageLiteral(resourceName: "ff_IconShoppingBag"), #imageLiteral(resourceName: "MoreGame")]
        ]
        // cell标题数组
        let mineCellTitles: [[String]] = [
            ["朋友圈"],
            ["扫一扫", "摇一摇"],
            ["附近的人"],
            ["购物", "游戏"]
        ]
        items(mineCellIcons, mineCellTitles)
        
        
    }
    
    class func getFindVCData() -> [[LXFSettingCellModel]] {
        return [
            [LXFSettingCellModel(icon: #imageLiteral(resourceName: "ff_IconShowAlbum"), title: "朋友圈")],
            [
                LXFSettingCellModel(icon: #imageLiteral(resourceName: "ff_IconQRCode"), title: "扫一扫"),
                LXFSettingCellModel(icon: #imageLiteral(resourceName: "ff_IconShake"), title: "摇一摇")
            ],
            [LXFSettingCellModel(icon: #imageLiteral(resourceName: "ff_IconLocationService"), title: "附近的人")],
            [
                LXFSettingCellModel(icon: #imageLiteral(resourceName: "ff_IconShoppingBag"), title: "购物"),
                // LXFSettingCellModel(icon: #imageLiteral(resourceName: "MoreGame"), title: "游戏")
                LXFSettingCellModel(icon: #imageLiteral(resourceName: "MoreGame"), title: "游戏", tipImg: "barbuttonicon_Luckymoney", tipTitle: "春节快来开手气", type: .default)
            ]
        ]
    }
    
    
    /* ============================================================ */
    
    
    // MARK:- 我
    // MARK: 我
    class func getMineVCData() -> [[LXFSettingCellModel]] {
        let avatarModel = LXFSettingCellModel(icon: #imageLiteral(resourceName: "SettingProfileHead"), title: LXFWeChatTools.shared.getMineInfo()?.userInfo?.nickName ?? "用户名",  tipImg: nil, tipTitle: nil, type: .avatar)
        avatarModel.subTitle = LXFWeChatTools.shared.getMineInfo()?.userId
        return [
            [avatarModel],
            [
                LXFSettingCellModel(icon: #imageLiteral(resourceName: "MoreMyAlbum"), title: "相册"),
                LXFSettingCellModel(icon: #imageLiteral(resourceName: "MoreMyFavorites"), title: "收藏"),
                LXFSettingCellModel(icon: #imageLiteral(resourceName: "MoreMyBankCard"), title: "钱包")
            ],
            [LXFSettingCellModel(icon: #imageLiteral(resourceName: "MoreExpressionShops"), title: "表情")],
            [LXFSettingCellModel(icon: #imageLiteral(resourceName: "MoreSetting"), title: "设置")]
        ]
    }
    // MARK: 设置
    class func getSettingVCData() -> [[LXFSettingCellModel]] {
        
        return [
            [LXFSettingCellModel(icon: nil, title: "帐号与安全")],
            [
                LXFSettingCellModel(icon: nil, title: "新消息通知"),
                LXFSettingCellModel(icon: nil, title: "隐私"),
                LXFSettingCellModel(icon: nil, title: "通用")
            ],
            [
                LXFSettingCellModel(icon: nil, title: "帮助与反馈"),
                LXFSettingCellModel(icon: nil, title: "关于微信")
            ],
            [LXFSettingCellModel(icon: nil, title: "退出登录", tipImg: nil, tipTitle: nil, type: .middle)]
        ]
    }
    // MARK: 关于微信
    class func getAboutVCData() -> [[LXFSettingCellModel]] {
        return [
            [
                LXFSettingCellModel(icon: nil, title: "去评分"),
                LXFSettingCellModel(icon: nil, title: "功能介绍"),
                LXFSettingCellModel(icon: nil, title: "系统通知"),
                LXFSettingCellModel(icon: nil, title: "投诉")
            ]
        ]
    }
    // MARK: 个人信息
    class func getProfileData() -> [[LXFSettingCellModel]] {
        let mineInfo = LXFWeChatTools.shared.getMineInfo()
        let genderEnum = (mineInfo?.userInfo?.gender) ?? .unknown
        var genderStr: String!
        switch genderEnum {
        case .female:
            genderStr = "女"
        case .male:
            genderStr = "男"
        default:
            genderStr = "未设置"
        }
        let userId = mineInfo?.userId ?? "未设置"
        let tipImgStr = mineInfo?.userInfo?.avatarUrl ?? "SettingProfileHead"
        
        return [
            [
                LXFSettingCellModel(icon: nil, title: "头像", tipImg: tipImgStr, tipTitle: nil, type: .avatar),
                LXFSettingCellModel(icon: nil, title: "名字", tipImg: nil, tipTitle: LXFWeChatTools.shared.getMineInfo()?.userInfo?.nickName ?? "未设置", type: .default),
                LXFSettingCellModel(icon: nil, title: "微信号", tipImg: nil, tipTitle: userId, type: .default),
                LXFSettingCellModel(icon: nil, title: "我的二维码", tipImg: "setting_myQR", tipTitle: nil, type: .default),
                LXFSettingCellModel(icon: nil, title: "我的地址", tipImg: nil, tipTitle: nil, type: .default)
            ],
            [
                LXFSettingCellModel(icon: nil, title: "性别", tipImg: nil, tipTitle: genderStr, type: .default),
                LXFSettingCellModel(icon: nil, title: "地区", tipImg: nil, tipTitle: "广东 深圳", type: .default),
                LXFSettingCellModel(icon: nil, title: "个性签名", tipImg: nil, tipTitle: "未填写", type: .default)
            ]
        ]
    }
}
