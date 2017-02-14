//
//  LXFChatEmotionHelper.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2017/1/1.
//  Copyright © 2017年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import UIKit

class LXFChatEmotionHelper: NSObject {
    
    // MARK:- 获取表情模型数组
    class func getAllEmotions() -> [LXFChatEmotion] {
        var emotions: [LXFChatEmotion] = [LXFChatEmotion]()
        let plistPath = Bundle.main.path(forResource: "Expression", ofType: "plist")
        let array = NSArray(contentsOfFile: plistPath!) as! [[String : String]]
        
        var index = 0
        for dict in array {
            emotions.append(LXFChatEmotion(dict: dict))
            index += 1
            if index == 23 {
                // 添加删除表情
                emotions.append(LXFChatEmotion(isRemove: true))
                index = 0
            }
        }
        
        // 添加空白表情
        emotions = self.addEmptyEmotion(emotiions: emotions)
        
        return emotions
    }
    
    // 添加空白表情
    fileprivate class func addEmptyEmotion(emotiions: [LXFChatEmotion]) -> [LXFChatEmotion] {
        var emos = emotiions
        let count = emos.count % 24
        if count == 0 {
            return emos
        }
        for _ in count..<23 {
            emos.append(LXFChatEmotion(isEmpty: true))
        }
        emos.append(LXFChatEmotion(isRemove: true))
        return emos
    }
    
    class func getImagePath(emotionName: String?) -> String? {
        if emotionName == nil {
            return nil
        }
        return Bundle.main.bundlePath + "/Expression.bundle/" + emotionName! + ".png"
    }
}
