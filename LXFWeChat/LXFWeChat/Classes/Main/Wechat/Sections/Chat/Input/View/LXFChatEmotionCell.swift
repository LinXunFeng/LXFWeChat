//
//  LXFChatEmotionCell.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2017/1/1.
//  Copyright © 2017年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import UIKit

class LXFChatEmotionCell: UICollectionViewCell {
    // MARK:- 定义属性
    var emotion: LXFChatEmotion? {
        didSet {
            guard let emo = emotion else { return }
            if emo.isRemove {
                emotionImageView.image = UIImage(named: "DeleteEmoticonBtn")
            } else if emo.isEmpty {
                emotionImageView.image = UIImage()
            } else {
                guard let imgPath = emo.imgPath else {
                    return
                }
                emotionImageView.image = UIImage(contentsOfFile: imgPath)
            }
        }
    }
    
    // MARK:- 懒加载
    lazy var emotionImageView: UIImageView = {
        return UIImageView()
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.addSubview(emotionImageView)
        emotionImageView.snp.makeConstraints { (make) in
            make.center.equalTo(self.snp.center)
            make.width.height.equalTo(32)
        }
    }
}
