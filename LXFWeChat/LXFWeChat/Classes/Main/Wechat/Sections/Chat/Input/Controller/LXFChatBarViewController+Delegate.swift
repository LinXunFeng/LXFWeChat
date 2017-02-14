//
//  LXFChatBarViewController+Delegate.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2017/1/3.
//  Copyright © 2017年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import Foundation

// MARK:- 实现代理方法
// MARK:- LXFChatBarViewDelegate
extension LXFChatBarViewController : LXFChatBarViewDelegate {
    
    func chatBarUpdateHeight(height: CGFloat) {
        barView.snp.updateConstraints { (make) in
            make.height.equalTo(height)
        }
        delegate?.chatBarUpdateHeight(height: height)
    }
    
    func chatBarShowTextKeyboard() {
        LXFLog("普通键盘")
        keyboardType = .text
        delegate?.chatBarShowTextKeyboard()
        delegate?.chatBarVC(chatBarVC: self, didChageChatBoxBottomDistance: keyboardFrame?.height ?? 0)
    }
    
    func chatBarShowMoreKeyboard() {
        LXFLog("更多面板")
        keyboardType = .more
        delegate?.chatBarShowMoreKeyboard()
        delegate?.chatBarVC(chatBarVC: self, didChageChatBoxBottomDistance: kNoTextKeyboardHeight)
    }
    
    func chatBarShowEmotionKeyboard() {
        LXFLog("表情面板")
        keyboardType = .emotion
        delegate?.chatBarShowEmotionKeyboard()
        delegate?.chatBarVC(chatBarVC: self, didChageChatBoxBottomDistance: kNoTextKeyboardHeight)
    }
    
    func chatBarShowVoice() {
        LXFLog("声音")
        keyboardType = .voice
        delegate?.chatBarShowVoice()
        delegate?.chatBarVC(chatBarVC: self, didChageChatBoxBottomDistance: 0)
    }
    
    func chatBarSendMessage() {
        LXFLog("发送信息")
        sendMessage()
    }
}
// MARK:- LXFChatEmotionViewDelegate
extension LXFChatBarViewController : LXFChatEmotionViewDelegate {
    func chatEmotionView(emotionView: LXFChatEmotionView, didSelectedEmotion emotion: LXFChatEmotion) {
        LXFLog(emotion)
        
        // 插入表情
        barView.inputTextView.insertEmotion(emotion: emotion)
    }
    func chatEmotionViewSend(emotionView: LXFChatEmotionView) {
        LXFLog("发送操作")
        sendMessage()
    }
}

// MARK:- LXFChatMoreViewDelegate
extension LXFChatBarViewController : LXFChatMoreViewDelegate {
    func chatMoreView(moreView: LXFChatMoreView, didSeletedType type: LXFChatMoreType) {
        LXFLog(type)
        if type == .pic {   // 图片
            // let imgPickerVC = TZImagePickerController(maxImagesCount: 9, columnNumber: 4, delegate: self)
            self.present(imgPickerVC, animated: true, completion: nil)
        } else if type == .sight {  // 小视频
            // let videoVC = KZVideoViewController()
            // videoVC.delegate = self
            videoVC.startAnimation(with: .small)
            // self.present(videoVC, animated: true, completion: nil)
        }
    }
}

// MARK:- TZImagePickerControllerDelegate 图片选择器代理
extension LXFChatBarViewController: TZImagePickerControllerDelegate {
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool, infos: [[AnyHashable : Any]]!) {
        for photo in photos {
            LXFWeChatTools.shared.sendImage(userId: user?.userId, image: photo)
        }
    }
}

// MARK:- KZVideoViewControllerDelegate
extension LXFChatBarViewController: KZVideoViewControllerDelegate {
    func videoViewController(_ videoController: KZVideoViewController!, didRecordVideo videoModel: KZVideoModel!) {
        // 视频本地路径
        let videoAbsolutePath = videoModel.videoAbsolutePath ?? ""
        LXFWeChatTools.shared.sendMedia(userId: user?.userId, filePath: videoAbsolutePath, type: .video)
        // 缩略图路径
        // let thumAbsolutePath = videoModel.thumAbsolutePath
        // 录制时间
        // let recordTime = videoModel.recordTime
    }
    
    func videoViewControllerDidCancel(_ videoController: KZVideoViewController!) {
        LXFLog("没有录到视频")
    }
}
