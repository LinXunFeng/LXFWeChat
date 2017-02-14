//
//  LXFFileManager.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2017/1/14.
//  Copyright © 2017年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import UIKit

class LXFFileManager: NSObject {
    // MARK:- 判断文件(夹)是否存在
    class func isExists(at path: String) -> Bool {
        return FileManager.default.fileExists(atPath: path)
    }
}
