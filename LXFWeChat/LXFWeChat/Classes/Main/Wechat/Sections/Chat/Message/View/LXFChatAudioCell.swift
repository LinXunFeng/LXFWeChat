//
//  LXFChatAudioCell.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2017/1/14.
//  Copyright © 2017年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import UIKit

class LXFChatAudioCell: LXFChatBaseCell {
    
    // MARK:- 模型
    override var model: LXFChatMsgModel? { didSet { setModel() } }
    
    // MARK:- 定义属性
    lazy var voiceButton: UIButton = {
        let voiceBtn = UIButton(type: .custom)
        voiceBtn.setImage(#imageLiteral(resourceName: "message_voice_receiver_normal"), for: .normal)
        voiceBtn.imageView?.animationDuration = 1
        voiceBtn.imageEdgeInsets = UIEdgeInsetsMake(-6, 0, 0, 0)
        voiceBtn.adjustsImageWhenHighlighted = false
        return voiceBtn
    }()
    lazy var durationLabel: UILabel = {
        let durationL = UILabel()
        durationL.font = UIFont.systemFont(ofSize: 12.0)
        durationL.text = "60\""
        durationL.textColor = RGBA(r: 0.61, g: 0.61, b: 0.61, a: 1.0)
        return durationL
    }()
    
    // MARK:- init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(voiceButton)
        addSubview(durationLabel)
        
        // 添加事件
        voiceButton.addTarget(self, action: #selector(playAudio), for: .touchUpInside)
        // 注册通知
        // 音频播放完毕
        NotificationCenter.default.addObserver(self, selector: #selector(audioPlayEnd(_:)), name: NSNotification.Name(rawValue: kNoteChatMsgAudioPlayEnd), object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK:- 事件处理
extension LXFChatAudioCell {
    // MARK: 播放录音
    @objc fileprivate func playAudio() {
        guard let audioPath = model?.audioPath else {
            return
        }
        // 关闭播放
        LXFWeChatTools.shared.stopPlayVoice()
        self.resetAudioAnimation()
        
        if LXFFileManager.isExists(at: audioPath) {
            LXFWeChatTools.shared.playVoice(with: audioPath)
            voiceButton.imageView?.startAnimating()
        } else {
            LXFNetworkTools.shared.download(urlStr: model?.audioUrl ?? "", savePath: audioPath, progress: nil, resultBlock: { [unowned self] (_, error) in
                if error != nil {
                    LXFLog(error)
                } else {
                    LXFWeChatTools.shared.playVoice(with: audioPath)
                    DispatchQueue.main.async(execute: {
                        self.voiceButton.imageView?.startAnimating()
                    })
                }
            })
        }
    }
    
    // MARK: 重置音频按钮动画(关闭动画)
    fileprivate func resetAudioAnimation() {
        voiceButton.imageView?.stopAnimating()
    }
    
    @objc fileprivate func audioPlayEnd(_ note: Notification) {
        let filePath = note.object as! String
        if filePath == model?.audioPath ?? "" {
            self.resetAudioAnimation()
        }
    }
}

// MARK:- 设置数据
extension LXFChatAudioCell {
    fileprivate func setModel() {
        guard let model = model else {
            return
        }
        model.cellHeight = 50
        
        durationLabel.text = "\(Int(ceil(model.audioDuration)))\""
        durationLabel.sizeToFit()
        var voiceWidth = 70 + 130 * CGFloat(model.audioDuration) / 60
        if voiceWidth > 200 { voiceWidth = 200 }
        
        // 设置泡泡
        let img = self.model?.userType == .me ? #imageLiteral(resourceName: "message_sender_background_normal") : #imageLiteral(resourceName: "message_receiver_background_normal")
        let normalImg = img.resizableImage(withCapInsets: UIEdgeInsetsMake(30, 28, 85, 28), resizingMode: .stretch)
        bubbleView.image = normalImg
        
        // 重新布局
        avatar.snp.remakeConstraints { (make) in
            make.width.height.equalTo(40)
            make.top.equalTo(self.snp.top)
        }
        voiceButton.snp.remakeConstraints { (make) in
            make.height.equalTo(35)
            make.width.equalTo(voiceWidth)
        }
        durationLabel.snp.remakeConstraints { (make) in
            make.height.equalTo(25)
            make.width.equalTo(durationLabel.width)
            make.bottom.equalTo(voiceButton.snp.bottom)
        }
        bubbleView.snp.remakeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(-2)
            make.bottom.equalTo(voiceButton.snp.bottom).offset(2)
        }
        tipView.snp.remakeConstraints { (make) in
            make.centerY.equalTo(avatar.snp.centerY)
            make.width.height.equalTo(30)
        }
        
        if model.userType == .me {
            avatar.snp.makeConstraints { (make) in
                make.right.equalTo(self.snp.right).offset(-10)
            }
            bubbleView.snp.makeConstraints { (make) in
                make.right.equalTo(avatar.snp.left).offset(-2)
                make.left.equalTo(voiceButton.snp.left).offset(-2)
            }
            voiceButton.snp.makeConstraints { (make) in
                make.top.equalTo(bubbleView.snp.top).offset(8)
                make.right.equalTo(bubbleView.snp.right).offset(-17)
            }
            tipView.snp.makeConstraints { (make) in
                make.right.equalTo(bubbleView.snp.left)
            }
            durationLabel.snp.makeConstraints({ (make) in
                make.right.equalTo(bubbleView.snp.left).offset(-6)
            })
            
            voiceButton.setImage(#imageLiteral(resourceName: "message_voice_sender_normal"), for: .normal)
            voiceButton.imageView?.animationImages = [
                #imageLiteral(resourceName: "message_voice_sender_playing_1"),
                #imageLiteral(resourceName: "message_voice_sender_playing_2"),
                #imageLiteral(resourceName: "message_voice_sender_playing_3")
            ]
            voiceButton.contentHorizontalAlignment = .right
        } else {
            avatar.snp.makeConstraints { (make) in
                make.left.equalTo(self.snp.left).offset(10)
            }
            
            bubbleView.snp.makeConstraints { (make) in
                make.left.equalTo(avatar.snp.right).offset(2)
                make.right.equalTo(voiceButton.snp.right).offset(2)
            }
            voiceButton.snp.makeConstraints { (make) in
                make.top.equalTo(bubbleView.snp.top).offset(8)
                make.left.equalTo(bubbleView.snp.left).offset(17)
            }
            tipView.snp.makeConstraints { (make) in
                make.left.equalTo(bubbleView.snp.right)
            }
            durationLabel.snp.makeConstraints({ (make) in
                make.left.equalTo(bubbleView.snp.right).offset(6)
            })
            
            voiceButton.setImage(#imageLiteral(resourceName: "message_voice_receiver_normal"), for: .normal)
            voiceButton.imageView?.animationImages = [
                #imageLiteral(resourceName: "message_voice_receiver_playing_1"),
                #imageLiteral(resourceName: "message_voice_receiver_playing_2"),
                #imageLiteral(resourceName: "message_voice_receiver_playing_3")
            ]
            voiceButton.contentHorizontalAlignment = .left
        }
    }
}
