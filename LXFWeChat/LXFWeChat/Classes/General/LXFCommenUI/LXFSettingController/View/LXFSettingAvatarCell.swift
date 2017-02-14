//
//  LXFSettingAvatarCell.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2017/1/27.
//  Copyright © 2017年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import UIKit

class LXFSettingAvatarCell: LXFSettingBaseCell {
    override var model: LXFSettingCellModel? {
        didSet {
            self.setModel()
        }
    }
    
    // MARK:- 懒加载
    lazy var iconView: UIImageView = {
        let iconV = UIImageView()
        return iconV
    }()
    
    lazy var titleLabel: UILabel = {
        let titleL = UILabel()
        titleL.font = UIFont.systemFont(ofSize: 17.0)
        return titleL
    }()
    
    lazy var subTitleLabel: UILabel = {
        let subTitleL = UILabel()
        subTitleL.font = UIFont.systemFont(ofSize: 12.0)
        subTitleL.textColor = UIColor.gray
        return subTitleL
    }()
    
    lazy var tipImgView: UIImageView = {
        let tipImgV = UIImageView()
        tipImgV.contentMode = .scaleAspectFit
        return tipImgV
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // 初始化UI
        self.setupUI()
        self.accessoryType = .disclosureIndicator
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK:- 初始化视图
extension LXFSettingAvatarCell {
    fileprivate func setupUI() {
        _ = self.subviews.map {
            //$0.classForCoder ==
            $0.removeFromSuperview()
        }
        // 添加视图
        self.addSubview(iconView)
        self.addSubview(titleLabel)
        self.addSubview(subTitleLabel)
        self.addSubview(tipImgView)
        
    }
}

// MARK:- 布局
extension LXFSettingAvatarCell {
    fileprivate func setModel() {
        
        // 设置数据
        iconView.isHidden = false
        iconView.image = model?.icon
        titleLabel.text = model?.title
        subTitleLabel.text = model?.subTitle
        tipImgView.image = #imageLiteral(resourceName: "setting_myQR")
        
        titleLabel.sizeToFit()
        subTitleLabel.sizeToFit()
        
        // 布局
        iconView.snp.remakeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(15)
            make.top.equalTo(self.snp.top).offset(8)
            make.bottom.equalTo(self.snp.bottom).offset(-8)
            make.width.equalTo(iconView.snp.height)
        }
        titleLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(15)
            make.bottom.equalTo(iconView.snp.centerY)
        }
        subTitleLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.left)
            make.top.equalTo(iconView.snp.centerY)
        }
        tipImgView.snp.remakeConstraints({ (make) in
            make.right.equalTo(self.snp.right).offset(-30)
            make.width.height.equalTo(18)
            make.centerY.equalTo(self.snp.centerY)
        })
        
        if model?.tipImg != nil {
            if UIImage(named: (model?.tipImg)!) != nil {
                tipImgView.image = UIImage(named: (model?.tipImg)!)
                tipImgView.contentMode = .scaleAspectFit
            } else {
                tipImgView.kf.setImage(with: URL(string: (model?.tipImg)!))
                tipImgView.contentMode = .scaleToFill
                iconView.isHidden = true
            }
            tipImgView.snp.updateConstraints({ (make) in
                make.width.height.equalTo(65)
                make.right.equalTo(self.snp.right).offset(-33)
            })
            titleLabel.snp.remakeConstraints({ (make) in
                make.top.bottom.equalTo(self)
                make.left.equalTo(self.snp.left).offset(15)
            })
            subTitleLabel.snp.remakeConstraints({ (make) in
                make.right.equalTo(self.snp.left)
            })
        }
        
        // 头像
        guard let avatarUrl = LXFWeChatTools.shared.getMineInfo()?.userInfo?.avatarUrl else {
            return
        }
        iconView.kf.setImage(with: URL(string: avatarUrl))
    }
}
