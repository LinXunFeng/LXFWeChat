//
//  LXFContactCell.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2016/12/28.
//  Copyright © 2016年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import UIKit

class LXFContactCell: UITableViewCell {
    
    // MARK:- 属性
    // MARK: 模型
    var model: LXFContactCellModel? {
        didSet {
            nickNameL.text = model?.title ?? ""
            avatarView.image = model?.image ?? #imageLiteral(resourceName: "Icon")
        }
    }
    
    // MARK: 拖线属性
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var nickNameL: UILabel!
}
