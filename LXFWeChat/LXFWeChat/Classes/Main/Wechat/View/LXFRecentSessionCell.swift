//
//  LXFRecentSessionCell.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2017/1/17.
//  Copyright © 2017年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import UIKit
import BadgeSwift

class LXFRecentSessionCell: UITableViewCell {
    
    var model: LXFRecentSessionModel! {
        didSet {
            setModel()
        }
    }
    
    // MARK:- 懒加载
    lazy var avatarView: UIImageView = {
        let avatarView = UIImageView()
        avatarView.image = #imageLiteral(resourceName: "Icon")
        avatarView.layer.cornerRadius = 5
        avatarView.layer.masksToBounds = true
        return avatarView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameL = UILabel()
        nameL.font = UIFont.systemFont(ofSize: 15.0)
        return nameL
    }()
    
    lazy var detailLabel: UILabel = {
        let detailL = UILabel()
        detailL.font = UIFont.systemFont(ofSize: 13.0)
        detailL.textColor = UIColor.gray
        return detailL
    }()
    
    lazy var timeLabel: UILabel = {
        let timeL = UILabel()
        timeL.font = UIFont.systemFont(ofSize: 13.0)
        timeL.textColor = UIColor.gray
        timeL.textAlignment = .right
        return timeL
    }()
    
    lazy var tipBadge: BadgeSwift = {
        let badge = BadgeSwift()
        badge.font = UIFont.systemFont(ofSize: 12.0)
        badge.textColor = UIColor.white
        badge.cornerRadius = 9
        badge.badgeColor = UIColor.red
        return badge
    }()
    
    // MARK:- init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // 初始化
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK:- 初始化
extension LXFRecentSessionCell {
    fileprivate func setup() {
        self.addSubview(avatarView)
        self.addSubview(nameLabel)
        self.addSubview(detailLabel)
        self.addSubview(timeLabel)
        self.addSubview(tipBadge)
        
        let margin: CGFloat = 10
        // 布局
        avatarView.snp.makeConstraints { (make) in
            make.left.top.equalTo(self).offset(margin)
            make.bottom.equalTo(self.snp.bottom).offset(-margin)
            make.height.equalTo(avatarView.snp.width)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatarView.snp.right).offset(margin)
            make.top.equalTo(avatarView.snp.top).offset(margin * 0.5)
            make.right.equalTo(self.snp.right)
            make.bottom.equalTo(avatarView.snp.centerY).offset(-5)
        }
        detailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp.left)
            make.bottom.equalTo(avatarView.snp.bottom).offset(-margin * 0.5)
            make.top.equalTo(avatarView.snp.centerY).offset(5)
            make.right.equalTo(self.snp.right).offset(-15)
        }
        timeLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self.snp.right).offset(-10)
            make.top.equalTo(nameLabel.snp.top)
        }
        tipBadge.snp.makeConstraints { (make) in
            make.centerX.equalTo(avatarView.snp.right)
            make.centerY.equalTo(avatarView.snp.top)
        }
    }
}

// MARK:- 设置数据
extension LXFRecentSessionCell {
    fileprivate func setModel() {
        avatarView.image = #imageLiteral(resourceName: "Icon")
        nameLabel.text = model.title
        detailLabel.text = model.subTitle
        timeLabel.text = model.time
        timeLabel.sizeToFit()
        if model.unreadCount == 0 {
            tipBadge.isHidden = true
        } else {
            tipBadge.isHidden = false
            tipBadge.text = "\(model.unreadCount)"
        }
    }
}
