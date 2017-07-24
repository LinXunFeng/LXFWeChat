//
//  LXFVideoChatController+Stream.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2017/7/24.
//  Copyright © 2017年 林洵锋. All rights reserved.
//

import UIKit
import LFLiveKit
import IJKMediaFramework

extension LXFVideoChatController {
    // 推流
    func pushStream(_ session: LFLiveSession) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
                let mediaType = AVMediaTypeVideo
                let authorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: mediaType)
                if (authorizationStatus == .restricted || authorizationStatus == .denied) {
                    // 摄像头不可用
                } else { // 摄像头可以用
                    let myUserId = LXFWeChatTools.shared.getMineInfo()?.userId
                    
                    // 开始推流
                    let stream = LFLiveStreamInfo()
                    let streamUrl = "\(kHostProtocol)://\(kHostAddress):\(kHostPort)/\(kHostPath)/\(myUserId ?? "lxf")" // 服务器地址
                    stream.url = streamUrl
                    session.startLive(stream)
                    session.running = true
                    
                    LXFLog("推流 --- streamUrl \(streamUrl)")
                }
            }
        }
    }
    
    // 拉流
    func pullStream(_ user: LXFContactCellModel?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // IJKPlayer默认使用的是软解码(FFMpeng)
            
            // 设置"videotoolbox"的值为0为软解码(默认)，设置为1则是硬解码
            let options = IJKFFOptions.byDefault()
            options?.setOptionIntValue(1, forKey: "videotoolbox", of: kIJKFFOptionCategoryPlayer)
            
            // IJKAVMoviePlayerController 用来播放本地视频
            let streamUrl = "\(kHostProtocol)://\(kHostAddress):\(kHostPort)/\(kHostPath)/\(user?.userId ?? "lxf")"
            let ijkPlayer = IJKFFMoviePlayerController(contentURLString: streamUrl, with: options)
            self.ijkPlayer = ijkPlayer
            ijkPlayer?.view.frame = self.view.bounds
            self.myCameraView.addSubview(ijkPlayer!.view)
            
            // 准备播放，当视频准备好的时候会自动进行播放
//            ijkPlayer?.prepareToPlay()
            
            LXFLog("拉流 --- streamUrl \(streamUrl)")
        }
    }
}
