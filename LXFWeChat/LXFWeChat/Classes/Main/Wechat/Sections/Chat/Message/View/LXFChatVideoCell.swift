//
//  LXFChatVideoCell.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2017/1/15.
//  Copyright © 2017年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import UIKit

class LXFChatVideoCell: LXFChatBaseCell {

    // MARK:- 模型
    override var model: LXFChatMsgModel? { didSet { setModel() } }
    
    // MARK:- 定义属性
    var chatImgView: UIImageView = UIImageView()
    var durationLabel: UILabel = {
        let durationL = UILabel()
        durationL.font = UIFont.systemFont(ofSize: 10.0)
        durationL.textColor = UIColor.white
        return durationL
    }()
    var playButton: UIButton = {
        let playBtn = UIButton(type: .custom)
        playBtn.setImage(#imageLiteral(resourceName: "MessageVideoPlay"), for: .normal)
        return playBtn
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(durationLabel)
        addSubview(playButton)
        
        // 添加事件
        playButton.addTarget(self, action: #selector(playVideo), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LXFChatVideoCell {
    @objc fileprivate func playVideo() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNoteChatMsgVideoPlayStart), object: model)
    }
}

// MARK:- 设置数据
extension LXFChatVideoCell {
    fileprivate func setModel() {
        if subviews.contains(chatImgView) {
            chatImgView.removeFromSuperview()
        }
        insertSubview(chatImgView, at: 1)
        
        // 数据
        LXFLog("urlStr --- \(model?.videoCoverUrl)")
        LXFLog("urlStrURL --- \(URL(string: model?.videoCoverUrl ?? ""))")
        LXFLog("videoDuration --- \(model?.videoDuration)")
        
        chatImgView.kf.setImage(with: URL(string: model?.videoCoverUrl ?? ""))
        durationLabel.text = self.getFormatDuration(with: model?.videoDuration)
        durationLabel.sizeToFit()
        
        // 获取缩略图size
        let thumbSize = LXFChatMsgDataHelper.shared.getThumbImageSize(model?.videoCoverSize ?? CGSize.zero)
        
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
            make.left.top.right.equalTo(chatImgView)
            make.bottom.equalTo(chatImgView.snp.bottom).offset(2)
        }
        tipView.snp.remakeConstraints { (make) in
            make.centerY.equalTo(avatar.snp.centerY)
            make.width.height.equalTo(30)
        }
        playButton.snp.remakeConstraints { (make) in
            make.center.equalTo(chatImgView.snp.center)
        }
        durationLabel.snp.remakeConstraints { (make) in
            make.right.equalTo(chatImgView.snp.right).offset(-10)
            make.bottom.equalTo(chatImgView.snp.bottom).offset(-3)
            make.width.equalTo(durationLabel.width)
            make.height.equalTo(durationLabel.height)
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

// MARK:- 格式化时间
extension LXFChatVideoCell {
    fileprivate func getFormatDuration(with duration: Int?) -> String {
        guard let duration = duration else {
            return "0:00"
        }
        let second = Int(round(Double(duration) / 1000.0))
        let minute = Int(round(Double(second) / 60.0))
        
        return String(format: "%d:%02d", minute, second)
    }
}
