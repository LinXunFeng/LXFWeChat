//
//  LXFChatController+Delegate.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2017/1/3.
//  Copyright © 2017年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import Foundation

// MARK:- LXFChatBarViewControllerDelegate
extension LXFChatController : LXFChatBarViewControllerDelegate {
    /* ============================= barView =============================== */
    func chatBarUpdateHeight(height: CGFloat) {
        chatBarVC.view.snp.updateConstraints { (make) in
            make.height.equalTo(height)
        }
    }
    
    func chatBarVC(chatBarVC: LXFChatBarViewController, didChageChatBoxBottomDistance distance: CGFloat) {
        LXFLog(distance)
        
        chatBarVC.view.snp.updateConstraints { (make) in
            make.bottom.equalTo(self.view.snp.bottom).offset(-distance)
        }
        UIView.animate(withDuration: kKeyboardChangeFrameTime, animations: {
            self.view.layoutIfNeeded()
        })
        
        if distance != 0 {
            chatMsgVC.scrollToBottom()
        }
    }
    
    func chatBarShowTextKeyboard() {
        UIView.animate(withDuration: kKeyboardChangeFrameTime) {
            self.emotionView.alpha = 0
            self.moreView.alpha = 0
        }
    }
    func chatBarShowVoice() {
        // 暂时没用
    }
    func chatBarShowEmotionKeyboard() {
        self.emotionView.alpha = 1
        self.moreView.alpha = 1
        moreView.snp.updateConstraints { (make) in
            make.top.equalTo(self.emotionView.snp.bottom)
        }
        UIView.animate(withDuration: kKeyboardChangeFrameTime) {
            self.view.layoutIfNeeded()
        }
    }
    func chatBarShowMoreKeyboard() {
        self.emotionView.alpha = 1
        self.moreView.alpha = 1
        moreView.snp.updateConstraints { (make) in
            make.top.equalTo(self.emotionView.snp.bottom).offset(-kNoTextKeyboardHeight)
        }
        UIView.animate(withDuration: kKeyboardChangeFrameTime) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK:- LXFChatMessageControllerDelegate
extension LXFChatController : LXFChatMsgControllerDelegate {
    func chatMsgVCWillBeginDragging(chatMsgVC: LXFChatMsgController) {
        // 还原barView的位置
        resetChatBarFrame()
    }
}

// MARK:- LXFWeChatToolsMediaDelegate
extension LXFChatController : LXFWeChatToolsMediaDelegate {
    /* ============================== 播放音频的回调 ============================== */
    // 准备开始播放音频
    func weChatToolsMediaPlayAudio(_ filePath: String, didBeganWithError error: Error?) {
        
    }
    // 音频播放结束
    func weChatToolsMediaPlayAudio(_ filePath: String, didCompletedWithError error: Error?) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNoteChatMsgAudioPlayEnd), object: filePath)
    }
    /* ============================== 录制音频 ============================== */
    // 准备开始录制
    func weChatToolsMediaRecordAudio(_ filePath: String?, didBeganWithError error: Error?) {
        recordVoiceView.recording()
    }
    // 录音停止
    func weChatToolsMediaRecordAudio(_ filePath: String, didCompletedWithError error: Error?) {
        LXFLog("filePath: --- \(filePath)")
        recordVoiceView.endRecord()
        if error != nil {
            LXFLog(error)
        } else {
            // 发送音频
            LXFWeChatTools.shared.sendMedia(userId: user?.userId, filePath: filePath, type: .audio)
        }
    }
    // 获得当前录音时长
    func weChatToolsMediaRecordAudioProgress(_ currentTime: TimeInterval) {
        let averagePower = LXFWeChatTools.shared.getRecordVoiceAveragePower()
        let level = pow(10, (0.05 * averagePower) * 10)
        LXFLog("level --- \(level)")
        recordVoiceView.updateMetersValue(level)
    }
    // 取消录音
    func weChatToolsMediaRecordAudioDidCancelled() {
        recordVoiceView.endRecord()
    }

}

