//
//  LXFChatImageCell.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2017/1/3.
//  Copyright © 2017年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import UIKit

class LXFChatImageCell: LXFChatBaseCell {
    
    // MARK:- 模型
    override var model: LXFChatMsgModel? { didSet { setModel() } }
    
    // MARK:- 定义属性
    lazy var chatImgView: UIImageView = { [unowned self] in
        let chatImgV = UIImageView()
        // 添加手势
        chatImgV.isUserInteractionEnabled = true
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(imgTap))
        chatImgV.addGestureRecognizer(tapGes)
        return chatImgV
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK:- 手势处理
extension LXFChatImageCell {
    @objc fileprivate func imgTap() {
        let objDic = ["model": model!, "view": chatImgView] as [String : Any]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNoteChatMsgTapImg), object: objDic)
    }
}


// MARK:- 设置数据
extension LXFChatImageCell {
    fileprivate func setModel() {
        if subviews.contains(chatImgView) {
            chatImgView.removeFromSuperview()
        }
        addSubview(chatImgView)
        
        chatImgView.kf.setImage(with: URL(string: model?.thumbUrl ?? ""))
        
        // 获取缩略图size
        let thumbSize = LXFChatMsgDataHelper.shared.getThumbImageSize(model?.imgSize ?? CGSize.zero)
        
        // 重新布局
        avatar.snp.remakeConstraints { (make) in
            make.width.height.equalTo(40)
            make.top.equalTo(self.snp.top)
        }
        chatImgView.snp.remakeConstraints { (make) in
            make.top.equalTo(avatar.snp.top)
            make.width.equalTo(thumbSize.width)
            make.height.equalTo(thumbSize.height)
        }
        bubbleView.snp.remakeConstraints { (make) in
            make.left.top.right.bottom.equalTo(chatImgView)
        }
        tipView.snp.remakeConstraints { (make) in
            make.centerY.equalTo(avatar.snp.centerY)
            make.width.height.equalTo(30)
        }
        
        if model?.userType == .me {
            avatar.snp.makeConstraints { (make) in
                make.right.equalTo(self.snp.right).offset(-10)
            }
            chatImgView.snp.makeConstraints { (make) in
                make.right.equalTo(avatar.snp.left).offset(-2)
            }
            tipView.snp.makeConstraints { (make) in
                make.right.equalTo(bubbleView.snp.left)
            }
            
        } else {
            avatar.snp.makeConstraints { (make) in
                make.left.equalTo(self.snp.left).offset(10)
            }
            chatImgView.snp.makeConstraints { (make) in
                make.left.equalTo(avatar.snp.right).offset(2)
            }
            tipView.snp.makeConstraints { (make) in
                make.left.equalTo(bubbleView.snp.right)
            }
        }
        
        model?.cellHeight = getCellHeight()
        
        // 绘制 imageView 的 bubble layer
        let stretchInsets = UIEdgeInsetsMake(30, 28, 23, 28)
        let stretchImage = model?.userType == .me ? #imageLiteral(resourceName: "SenderImageNodeMask") : #imageLiteral(resourceName: "ReceiverImageNodeMask")
        self.chatImgView.clipShape(stretchImage: stretchImage, stretchInsets: stretchInsets)

        // 绘制coerImage 盖住图片
        let stretchCoverImage = model?.userType == .me ? #imageLiteral(resourceName: "SenderImageNodeBorder") : #imageLiteral(resourceName: "ReceiverImageNodeBorder")
        let bubbleCoverImage = stretchCoverImage.resizableImage(withCapInsets: stretchInsets, resizingMode: .stretch)
        bubbleView.image = bubbleCoverImage
        
    }
}

