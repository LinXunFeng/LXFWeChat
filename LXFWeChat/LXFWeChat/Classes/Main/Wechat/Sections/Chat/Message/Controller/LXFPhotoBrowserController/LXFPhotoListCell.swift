//
//  LXFPhotoListCell.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2017/1/9.
//  Copyright © 2017年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import UIKit

class LXFPhotoListCell: UICollectionViewCell {
    
    // MARK:- 懒加载
    lazy var imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = #imageLiteral(resourceName: "LaunchImage")
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 初始化
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- 初始化
    func setup() {
        self.addSubview(imgView)
        imgView.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalTo(self)
        }
    }
}

