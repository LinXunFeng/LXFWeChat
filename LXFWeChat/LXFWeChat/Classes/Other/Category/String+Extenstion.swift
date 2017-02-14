//
//  String+Extenstion.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2016/12/26.
//  Copyright © 2016年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import Foundation

// MARK:- 登录专用
extension String {
    func MD5String() -> String {
        // CC_MD5 需要 #import <CommonCrypto/CommonDigest.h>
        let cStr = self.cString(using: String.Encoding.utf8);
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(cStr!,(CC_LONG)(strlen(cStr!)), buffer)
        let md5String = NSMutableString();
        for i in 0 ..< 16{
            md5String.appendFormat("%02x", buffer[i])
        }
        free(buffer)
        return md5String as String
    }
    
    func tokenByPassword() -> String {
        return self.MD5String()
    }
    
}

// MARK:- 通讯录
extension String {
    // 判断是否为字母
    func isAlpha() -> Bool {
        if self == "" {
            return false
        }
        for chr in self.characters {
            let chrStr = chr.description
            if (!(chrStr >= "a" && chrStr <= "z") && !(chrStr >= "A" && chrStr <= "Z") ) {
                LXFLog("false")
                return false
            }
        }
        LXFLog("true")
        return true
    }
    
    // 拼音
    func pinyin() -> String {
        let str = NSMutableString(string: self)
        CFStringTransform(str as CFMutableString, nil, kCFStringTransformMandarinLatin, false)
        CFStringTransform(str as CFMutableString, nil, kCFStringTransformStripDiacritics, false)
        return str.replacingOccurrences(of: " ", with: "")
    }
}

extension String {
    // MARK:- 获取字符串的CGSize
    func getSize(with font: UIFont) -> CGSize {
        return getSize(width: UIScreen.main.bounds.width, font: font)
    }
    // MARK:- 获取字符串的CGSize(指定宽度)
    func getSize(width: CGFloat, font: UIFont) -> CGSize {
        let str = self as NSString
        
        let size = CGSize(width: width, height: CGFloat(FLT_MAX))
        return str.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil).size
    }
}

