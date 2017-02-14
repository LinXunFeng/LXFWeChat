//
//  LXFSpaceSizeTools.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2017/1/7.
//  Copyright © 2017年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import UIKit

class LXFSpaceSizeTools: NSObject {
    static let shared: LXFSpaceSizeTools = LXFSpaceSizeTools()
}

// MARK:- 获取空间大小对应的文字说明
extension LXFSpaceSizeTools {
    func getSizeString(size: Int) -> String {
        let size:CGFloat      = CGFloat(size)
        let sizeUnit: CGFloat = 1024.0
        if size < sizeUnit { // B
            return String(format: "%lldB", size)
        } else if size < sizeUnit * sizeUnit {  // KB
            return String(format: "%.1fKB", size / sizeUnit)
        } else if size < sizeUnit * sizeUnit * sizeUnit {   // MB
            return String(format: "%.1fMB", size / (sizeUnit * sizeUnit))
        } else{ // GB
            return String(format: "%.1fG", size / (sizeUnit * sizeUnit * sizeUnit))
        }
    }
}
