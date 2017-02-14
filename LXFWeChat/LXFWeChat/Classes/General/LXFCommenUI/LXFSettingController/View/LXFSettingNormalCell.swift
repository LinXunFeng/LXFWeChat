//
//  LXFSettingNormalCell.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2017/1/26.
//  Copyright © 2017年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import UIKit

class LXFSettingNormalCell: LXFSettingBaseCell {
    
    override var model: LXFSettingCellModel? {
        didSet {
            self.setModel()
        }
    }
    
    var isShowIndicator: Bool = true
    
    // MARK:- 懒加载
    lazy var iconView: UIImageView = {
        let iconV = UIImageView()
        return iconV
    }()
    
    lazy var titleLabel: UILabel = {
        let titleL = UILabel()
        return titleL
    }()
    
    lazy var tipImgView: UIImageView = {
        let tipImgV = UIImageView()
        tipImgV.contentMode = .center
        return tipImgV
    }()
    
    lazy var tipTitleLabel: UILabel = {
        let tipTitleL = UILabel()
        tipTitleL.textColor = UIColor.lightGray
        tipTitleL.font = UIFont.systemFont(ofSize: 14.0)
        tipTitleL.textAlignment = .right
        return tipTitleL
    }()
    
    // MARK:- init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // 初始化UI
        self.setupUI()
        
        self.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK:- 初始化
extension LXFSettingNormalCell {
    fileprivate func setupUI() {
        _ = self.subviews.map {
            $0.removeFromSuperview()
        }
        // 添加视图
        self.addSubview(iconView)
        self.addSubview(titleLabel)
        self.addSubview(tipImgView)
        self.addSubview(tipTitleLabel)
        
    }
}

// MARK:- 布局
extension LXFSettingNormalCell {
    fileprivate func setModel() {
        // 设置数据
        if let icon = model?.icon {
            iconView.isHidden = false
            iconView.image = icon
        } else {
            iconView.isHidden = true
        }
        if let title = model?.title {
            titleLabel.isHidden = false
            titleLabel.text = title
            titleLabel.sizeToFit()
        } else {
            titleLabel.isHidden = true
        }
        if let tipImg = model?.tipImg {
            tipImgView.isHidden = false
            tipImgView.image = UIImage(named: tipImg)
        } else {
            tipImgView.isHidden = true
        }
        if let tipTitle = model?.tipTitle {
            tipTitleLabel.isHidden = false
            tipTitleLabel.text = tipTitle
            tipTitleLabel.sizeToFit()
        } else {
            tipTitleLabel.isHidden = true
        }
        if model?.type != .default {
            self.accessoryType = .none
            self.isShowIndicator = false
        } else {
            self.accessoryType = .disclosureIndicator
            self.isShowIndicator = true
        }
        
        // 布局
        if model?.icon != nil {
            iconView.snp.remakeConstraints({ (make) in
                make.left.equalTo(self.snp.left).offset(16)
                make.width.height.equalTo(25)
                make.centerY.equalTo(self.snp.centerY)
            })
            titleLabel.snp.remakeConstraints({ (make) in
                make.left.equalTo(iconView.snp.right).offset(15)
                make.top.bottom.equalTo(self)
            })
        } else {
            titleLabel.snp.remakeConstraints({ (make) in
                make.left.equalTo(self.snp.left).offset(15)
                make.top.bottom.equalTo(self)
            })
        }
        
        
        let rightMargin: CGFloat = isShowIndicator ? -33 : -10
        if model?.tipImg != nil {
            tipImgView.snp.remakeConstraints({ (make) in
                make.right.equalTo(self.snp.right).offset(rightMargin)
                make.width.height.equalTo(25)
                make.centerY.equalTo(self.snp.centerY)
            })
        }
        
        if model?.tipTitle != nil {
            tipTitleLabel.snp.remakeConstraints({ (make) in
                make.top.bottom.equalTo(self)
            })
            if model?.tipImg != nil {
                tipTitleLabel.snp.makeConstraints({ (make) in
                    make.right.equalTo(tipImgView.snp.left)
                })
            } else {
                tipTitleLabel.snp.makeConstraints({ (make) in
                    make.right.equalTo(self.snp.right).offset(rightMargin)
                })
            }
        }
    }
}
