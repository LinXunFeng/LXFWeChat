//
//  LXFSettingMiddleCell.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2017/1/28.
//  Copyright © 2017年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import UIKit

class LXFSettingMiddleCell: LXFSettingBaseCell {
    override var model: LXFSettingCellModel? {
        didSet {
            self.setModel()
        }
    }
    
    // MARK:- 懒加载
    lazy var titleLabel: UILabel = {
        let titleL = UILabel()
        titleL.textAlignment = .center
        return titleL
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(titleLabel)
        // 布局
        titleLabel.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LXFSettingMiddleCell {
    fileprivate func setModel() {
        titleLabel.text = model?.title
    }
}
