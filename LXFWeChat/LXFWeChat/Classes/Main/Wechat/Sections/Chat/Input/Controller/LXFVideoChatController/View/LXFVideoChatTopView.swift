//
//  LXFVideoChatTopView.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2017/7/23.
//  Copyright © 2017年 林洵锋. All rights reserved.
//

import UIKit

class LXFVideoChatTopView: UIView {
    
    fileprivate var imageUrl: String
    fileprivate var userName: String
    
    fileprivate lazy var avatarImageView: UIImageView = { [unowned self] in
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        self.addSubview(imageView)
        return imageView
    }()
    
    fileprivate lazy var userNameLabel: UILabel = { [unowned self] in
        let userNameLabel = UILabel()
        userNameLabel.text = self.userName
        userNameLabel.font = UIFont.systemFont(ofSize: 25)
        userNameLabel.textColor = UIColor.white
        self.addSubview(userNameLabel)
        return userNameLabel
    }()
    
    fileprivate lazy var descLabel: UILabel = { [unowned self] in
        let descLabel = UILabel()
        descLabel.text = "正在等待对方接受邀请..."
        descLabel.font = UIFont.systemFont(ofSize: 15)
        descLabel.textColor = UIColor.white
        self.addSubview(descLabel)
        return descLabel
    }()

    init(imageUrl: String?, userName: String) {
        self.imageUrl = imageUrl ?? ""
        self.userName = userName
        super.init(frame: CGRect.zero)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LXFVideoChatTopView {
    func setupUI() {
        // 头像
        avatarImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(self.snp.height)
            make.centerY.equalTo(self.snp.centerY)
            make.left.equalTo(self.snp.left).offset(15)
        }
        avatarImageView.image = #imageLiteral(resourceName: "Icon")
        
        // 用户名
        userNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatarImageView.snp.right).offset(15)
            make.top.equalTo(avatarImageView.snp.top).offset(5)
            make.right.equalTo(self.snp.right)
            make.height.equalTo(self.snp.height).multipliedBy(0.7)
        }
        
        // 描述
//        descLabel.snp.makeConstraints { (make) in
//            make.left.equalTo(userNameLabel.snp.left)
//            make.right.equalTo(self.snp.right)
//            make.top.equalTo(userNameLabel.snp.bottom)
//            make.bottom.equalTo(avatarImageView.snp.bottom).offset(-5)
//        }
        
        
    }
}
