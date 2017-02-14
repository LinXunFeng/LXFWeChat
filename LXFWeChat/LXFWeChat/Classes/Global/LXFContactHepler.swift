//
//  LXFContactHepler.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2016/12/28.
//  Copyright © 2016年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import UIKit

class LXFContactHepler: NSObject {
    // MARK:- 将联系人进行排序和分组操作
    class func getFriendListData(by array: [LXFContactCellModel]) -> [[LXFContactCellModel]] {
        // 排序 (升序)
        let serializedArr = array.sorted { (obj1, obj2) -> Bool in
            let strA = obj1.pinyin ?? ""
            let strB = obj2.pinyin ?? ""
            
            var i = 0
            while i < strA.characters.count && i < strB.characters.count {
                let a = strA.index(strA.startIndex, offsetBy: i)
                let b = strB.index(strB.startIndex, offsetBy: i)
                if a < b {
                    return true
                } else if a > b {
                    return false
                }
                i += 1
            }
            if strA.characters.count < strB.characters.count {
                return true
            } else if strA.characters.count > strB.characters.count {
                return false
            }
            
            return false
        }
        
        // 降序
        // serializedArr = serializedArr.reversed()
        
        // 分组
        var lastC = "1"
        var ans = [[LXFContactCellModel]]()
        var data: [LXFContactCellModel]?
        var other = [LXFContactCellModel]()
        for user in serializedArr {
            let pinyin = user.pinyin ?? ""
            let c = pinyin.characters.first?.description ?? ""
            if !c.isAlpha() {
                other.append(user)
            } else if c != lastC {
                lastC = c
                if (data != nil) && data!.count > 0 {
                    ans.append(data!)
                }
                data = [LXFContactCellModel]()
                data?.append(user)
            } else {
                data!.append(user)
            }
        }
        if (data != nil) && data!.count > 0 {
            ans.append(data!)
        }
        if other.count > 0 {
            ans.append(other)
        }
        return ans
    }
    
    // 获取索引
    class func getFriendListSection(by array: [[LXFContactCellModel]]) -> [String] {
        var section = [String]()
        section.append(UITableViewIndexSearch) // 添加放大镜
        for item in array {
            let user = item.first
            var c = user?.pinyin?.characters.first?.description ?? ""
            if !c.isAlpha() {
                c = "#"
            }
            section.append(c.uppercased())
        }
        return section
    }
}
