//
//  LXFWeChatTools+Update.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2017/2/3.
//  Copyright © 2017年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import Foundation

enum LXFWeChatToolsUpdateType {
    case nickName   // 昵称
    case avatar     // 头像
    case sign       // 签名
    case gender     // 性别
}

enum LXFWeChatToolsGender {
    case male       // 男
    case female     // 女
    case unknow     // 未知
}


extension LXFWeChatTools {
    // MARK: 更新头像
    func updateAvatar(with image: UIImage) {
        
        let imgData = UIImageJPEGRepresentation(image, 0.5)
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        let totalPath = documentPath! + "userAvatar"
        guard ((try? imgData!.write(to: URL(fileURLWithPath: totalPath))) != nil) else {
            return
        }
        
        LXFProgressHUD.lxf_showWithStatus("正在上传")
        
        NIMSDK.shared().resourceManager.upload(totalPath, progress: nil) { [unowned self] (urlString, error) in
            if error != nil {
                LXFLog(error)
                LXFProgressHUD.lxf_showError(withStatus: "上传失败")
            } else {
                LXFLog(urlString)
                guard let urlStr = urlString else {
                    LXFProgressHUD.lxf_showError(withStatus: "未获得头像地址")
                    return
                }
                self.update(with: urlStr, type: .avatar)
                LXFProgressHUD.lxf_showSuccess(withStatus: "上传成功")
            }
        }
    }
    
    // MARK: 更新签名
    func updateSign(with sign: String) {
        self.update(with: sign, type: .sign)
    }
    // MARK: 更新昵称
    func updateNickName(with nickName: String) {
        self.update(with: nickName, type: .nickName)
    }
    // MARK: 更新性别
    func updateGender(with gender: LXFWeChatToolsGender) {
        var userGender: NIMUserGender!
        switch gender {
        case .male:
            userGender = NIMUserGender.male
        case .female:
            userGender = NIMUserGender.female
        default:
            userGender = NIMUserGender.unknown
            break
        }
        
        self.update(with: "", type: .gender, gender: userGender)
    }
    
}

// MARK:- 修改用户信息(string)
extension LXFWeChatTools {
    fileprivate func update(with str: String, type: LXFWeChatToolsUpdateType, gender: NIMUserGender? = nil) {
        
        var key: NSNumber!
        switch type {
        case .nickName:
            key = NSNumber(value: NIMUserInfoUpdateTag.nick.rawValue)
        case .avatar:
            key = NSNumber(value: NIMUserInfoUpdateTag.avatar.rawValue)
        case .sign:
            key = NSNumber(value: NIMUserInfoUpdateTag.sign.rawValue)
        case .gender:
            key = NSNumber(value: NIMUserInfoUpdateTag.gender.rawValue)
        }
        
        var dict: [NSNumber : String] = [key: str]
        if type == .gender {
            dict = [key: "\(gender!.rawValue)"]
        }
        
        NIMSDK.shared().userManager.updateMyUserInfo(dict) { (error) in
            if error != nil {
                LXFLog(error)
            } else {
                LXFLog("修改成功")
                // 返回通知
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNoteWeChatGoBack), object: type)
            }
        }
        
    }
}



