//
//  LXFChatTimeCell.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2017/1/8.
//  Copyright © 2017年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import UIKit

class LXFChatTimeCell: UITableViewCell {
    // MARK:- 模型
    var model: LXFChatMsgModel? {
        didSet {
            setModel()
        }
    }
    // MARK:- 懒加载
    lazy var timeLabel: UILabel = {
        let timeL = UILabel()
        timeL.textColor = UIColor.white
        timeL.font = UIFont.systemFont(ofSize: 12.0)
        return timeL
    }()
    
    lazy var bgView: UIView = {
        let bg = UIView()
        bg.layer.cornerRadius = 4
        bg.layer.masksToBounds = true
        bg.backgroundColor = normalRGBA(r: 190.0, g: 190.0, b: 190.0, a: 0.6)
        return bg
    }()
    
    // MARK:- init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        self.addSubview(bgView)
        self.addSubview(timeLabel)
        
        bgView.snp.makeConstraints { (make) in
            make.left.equalTo(timeLabel.snp.left).offset(-4)
            make.top.equalTo(timeLabel).offset(-1)
            make.right.equalTo(timeLabel).offset(4)
            make.bottom.equalTo(timeLabel).offset(1)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LXFChatTimeCell {
    fileprivate func setModel() {
        guard let model = model else {
            return
        }
        model.cellHeight = 40
        
        timeLabel.text = LXFChatMsgTimeHelper.shared.chatTimeString(with: model.time)
        timeLabel.sizeToFit()
        timeLabel.snp.remakeConstraints { (make) in
            make.width.equalTo(timeLabel.width)
            make.height.equalTo(timeLabel.height)
            make.center.equalTo(self.snp.center)
        }
    }
}

extension LXFChatTimeCell {
    // MARK:- 获取cell的高度
    func getCellHeight() -> CGFloat {
        return 40.0
    }
}
