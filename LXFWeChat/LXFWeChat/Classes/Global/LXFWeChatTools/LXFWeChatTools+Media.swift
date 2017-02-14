//
//  LXFWeChatTools+Media.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2017/1/12.
//  Copyright © 2017年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import Foundation

protocol LXFWeChatToolsMediaDelegate: NSObjectProtocol {
    /* ============================== 播放音频的回调 ============================== */
    // 准备开始播放音频
    func weChatToolsMediaPlayAudio(_ filePath: String, didBeganWithError error: Error?)
    // 音频播放结束
    func weChatToolsMediaPlayAudio(_ filePath: String, didCompletedWithError error: Error?)
    /* ============================== 录制音频 ============================== */
    // 准备开始录制
    func weChatToolsMediaRecordAudio(_ filePath: String?, didBeganWithError error: Error?)
    // 录音停止
    func weChatToolsMediaRecordAudio(_ filePath: String, didCompletedWithError error: Error?)
    // 获得当前录音时长
    func weChatToolsMediaRecordAudioProgress(_ currentTime: TimeInterval)
    // 取消录音
    func weChatToolsMediaRecordAudioDidCancelled()
    /* ============================== 来电打断的回调 ============================== */
    /*
     *  本项目仅为练手项目，所以这部分就暂不使用了
    // 正在播放音频 被打断
    func weChatToolsMediaPlayAudioInterruptionBegin()
    // 正在录音 被打断
    func weChatToolsMediaRecordAudioInterruptionBegin()
    // 正在播放音频 被打断后 通话结束
    func weChatToolsMediaPlayAudioInterruptionEnd()
    // 正在录音 被打断 通话结束
    func weChatToolsMediaRecordAudioInterruptionEnd()
    */
}

enum LXFWechatMediaOutputDeviceType {
    case receiver   // 听筒
    case speaker    // 扬声器
}

// MARK:- 播放音频
extension LXFWeChatTools {
    // MARK: 切换音频的输出设备
    func switchAudioOutputDevice(type: LXFWechatMediaOutputDeviceType = .speaker) {
        var outputDevice: NIMAudioOutputDevice = .speaker
        if type == .receiver {
            outputDevice = .receiver
        }
        NIMSDK.shared().mediaManager.switch(outputDevice)
    }
    // MARK: 判断是否正在播放音频
    func isPlayingVoice() -> Bool {
        return NIMSDK.shared().mediaManager.isPlaying()
    }
    // MARK: 播放音频
    func playVoice(with filePath: String) {
        NIMSDK.shared().mediaManager.play(filePath)
    }
    // MARK: 停止播放音频
    func stopPlayVoice() {
        NIMSDK.shared().mediaManager.stopPlay()
    }
}

// MARK:- 录制音频
extension LXFWeChatTools {
    // MARK: 判断是否正在录制音频
    func isRecordingVoice() -> Bool {
        return NIMSDK.shared().mediaManager.isRecording()
    }
    // MARK: 录制音频
    // 其中 duration 限制了录音的最大时长
    func recordVoice(duration: TimeInterval = 60.0) {
        NIMSDK.shared().mediaManager.record(forDuration: duration)
    }
    // MARK: 设置录音回调的时间间隔
    func setRecordCallbackInterval(with time: TimeInterval) {
        NIMSDK.shared().mediaManager.recordProgressUpdateTimeInterval = time
    }
    // MARK: 停止录制音频
    func stopRecordVoice() {
        NIMSDK.shared().mediaManager.stopRecord()
    }
    // MARK: 取消录音
    func cancelRecordVoice() {
        NIMSDK.shared().mediaManager.cancelRecord()
    }
    // MARK: 获取录音分贝
    // MARK: 获取峰值
    func getRecordVoicePeakPower() -> Float {
        return NIMSDK.shared().mediaManager.recordPeakPower()
    }
    // MARK: 获取平均值
    func getRecordVoiceAveragePower() -> Float {
        return NIMSDK.shared().mediaManager.recordAveragePower()
    }
}

// MARK:- NIMMediaManagerDelgate
extension LXFWeChatTools: NIMMediaManagerDelgate {
    /* ============================== 播放音频的回调 ============================== */
    // MARK: 准备开始播放音频 回调
    // 初始化工作完成，准备开始播放音频的时候会触发
    func playAudio(_ filePath: String, didBeganWithError error: Error?) {
        LXFLog("准备开始播放音频")
        mediaDelegate?.weChatToolsMediaPlayAudio(filePath, didBeganWithError: error)
    }
    // MARK: 音频播放结束 回调
    // 音频播放结束的时候会触发
    // <播放音频> 结束后 和 <停止播放音频> 时 会调用该方法
    func playAudio(_ filePath: String, didCompletedWithError error: Error?) {
        LXFLog("音频播放结束")
        mediaDelegate?.weChatToolsMediaPlayAudio(filePath, didCompletedWithError: error)
    }
    
    /* ============================== 录制音频的回调 ============================== */
    // MARK: 准备开始录制 回调
    // 初始化工作完成，准备开始录制的时候会触发
    func recordAudio(_ filePath: String?, didBeganWithError error: Error?) {
        LXFLog("开始录制")
        mediaDelegate?.weChatToolsMediaRecordAudio(filePath, didBeganWithError: error)
    }
    // MARK: 录音停止 回调
    // 当到录音时长达到设置的最大时长，或者手动停止录音会触发
    // 触发： <录制音频> 结束后 和 <停止录制音频> 时
    func recordAudio(_ filePath: String, didCompletedWithError error: Error?) {
        LXFLog("录音停止")
        mediaDelegate?.weChatToolsMediaRecordAudio(filePath, didCompletedWithError: error)
    }
    // MARK: 获得当前录音时长 回调
    // 按照一定的时间间隔触发 默认为 0.3 秒
    func recordAudioProgress(_ currentTime: TimeInterval) {
        LXFLog("当前的录音时长 - \(currentTime)")
        mediaDelegate?.weChatToolsMediaRecordAudioProgress(currentTime)
    }
    // MARK: 取消录音 回调
    func recordAudioDidCancelled() {
        LXFLog("取消录音")
        mediaDelegate?.weChatToolsMediaRecordAudioDidCancelled()
    }
    
    /* ============================== 来电打断的回调 ============================== */
    // MARK: 正在播放音频 被打断 回调
    func playAudioInterruptionBegin() {
        LXFLog("正在播放音频 被打断")
    }
    // MARK: 正在录音 被打断 回调
    func recordAudioInterruptionBegin() {
        LXFLog(" 正在录音 被打断")
    }
    // MARK: 正在播放音频 被打断后 通话结束 回调
    func playAudioInterruptionEnd() {
        LXFLog("正在播放音频 被打断 --- 通话结束 回调")
    }
    // MARK: 正在录音 被打断 通话结束 回调
    func recordAudioInterruptionEnd() {
        LXFLog("正在录音 被打断 --- 通话结束 回调")
    }
}
