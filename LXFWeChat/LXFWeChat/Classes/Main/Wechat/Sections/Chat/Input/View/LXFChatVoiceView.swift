//
//  LXFChatVoiceView.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2017/1/11.
//  Copyright © 2017年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import UIKit

class LXFChatVoiceView: UIView {
    // MARK:- 懒加载
    lazy var centerView: UIView = {
        let centerV = UIView()
        centerV.backgroundColor = RGBA(r: 0, g: 0, b: 0, a: 0.5)
        return centerV
    }()
    lazy var noteLabel: UILabel = {
        let noteL = UILabel()
        noteL.text = "松开手指，取消发送"
        noteL.font = UIFont.systemFont(ofSize: 14.0)
        noteL.textColor = UIColor.white
        noteL.textAlignment = .center
        noteL.layer.cornerRadius = 2
        noteL.layer.masksToBounds = true
        return noteL
    }()
    lazy var cancelImgView: UIImageView = {
        let cancelImgV = UIImageView(image: #imageLiteral(resourceName: "RecordCancel"))
        return cancelImgV
    }()
    lazy var tooShortImgView: UIImageView = {
        let tooShortImgV = UIImageView(image: #imageLiteral(resourceName: "MessageTooShort"))
        return tooShortImgV
    }()
    lazy var recordingView: UIView = {
        let recordingV = UIView()
        return recordingV
    }()
    lazy var recordingBkg: UIImageView = {
        let recordingBkg = UIImageView(image: #imageLiteral(resourceName: "RecordingBkg"))
        recordingBkg.layer.cornerRadius = 5
        recordingBkg.layer.masksToBounds = true
        return recordingBkg
    }()
    var signalValueImgView: UIImageView = UIImageView(image: #imageLiteral(resourceName: "RecordingSignal008"))
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK:- 初始化
extension LXFChatVoiceView {
    fileprivate func setup() {
        // 添加视图
        self.addSubview(centerView)
        centerView.addSubview(noteLabel)
        centerView.addSubview(cancelImgView)
        centerView.addSubview(tooShortImgView)
        centerView.addSubview(recordingView)
        recordingView.addSubview(recordingBkg)
        recordingView.addSubview(signalValueImgView)
        
        // 布局
        centerView.snp.makeConstraints { (make) in
            make.width.height.equalTo(150)
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY).offset(-30)
        }
        noteLabel.snp.makeConstraints { (make) in
            make.left.equalTo(centerView.snp.left).offset(8)
            make.right.equalTo(centerView.snp.right).offset(-8)
            make.bottom.equalTo(centerView.snp.bottom).offset(-6)
            make.height.equalTo(20)
        }
        cancelImgView.snp.makeConstraints { (make) in
            make.width.height.equalTo(100)
            make.centerX.equalTo(centerView.snp.centerX)
            make.top.equalTo(centerView.snp.top).offset(14)
        }
        tooShortImgView.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalTo(cancelImgView)
        }
        recordingView.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalTo(cancelImgView)
        }
        recordingBkg.snp.makeConstraints { (make) in
            make.top.left.bottom.equalTo(recordingView)
            make.width.equalTo(62)
        }
        signalValueImgView.snp.makeConstraints { (make) in
            make.top.right.bottom.equalTo(recordingView)
            make.left.equalTo(recordingBkg.snp.right)
        }
    }
}

// MARK:- 对外提供的方法
extension LXFChatVoiceView {
    // MARK: 正在录音
    func recording() {
        self.isHidden = false
        self.cancelImgView.isHidden = true
        self.tooShortImgView.isHidden = true
        self.recordingView.isHidden = false
        self.noteLabel.backgroundColor = UIColor.clear
        self.noteLabel.text = "手指上滑，取消发送"
    }
    // MARK: 滑动取消
    func slideToCancelRecord() {
        self.isHidden = false
        self.cancelImgView.isHidden = false
        self.tooShortImgView.isHidden = true
        self.recordingView.isHidden = true
        self.noteLabel.backgroundColor = UIColor.hexInt(0x9C3638)
        self.noteLabel.text = "松开手指，取消发送"
    }
    // MARK: 提示录音时间太短
    func messageTooShort() {
        self.isHidden = false
        self.cancelImgView.isHidden = true
        self.tooShortImgView.isHidden = false
        self.recordingView.isHidden = true
        self.noteLabel.backgroundColor = UIColor.clear
        self.noteLabel.text = "说话时间太短"
        // 0.5秒后消失
        let delayTime =  DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            self.endRecord()
        }
    }
    // MARK: 录音结束
    func endRecord() {
        self.isHidden = true
    }
    // MARK: 更新麦克风的音量大小
    func updateMetersValue(_ value: Float) {
        // var index = Int(round(value))
        // value = 1.34191e-07
        var index = Int(String(value).characters.first?.description ?? "0") ?? 0
        
        index = index > 7 ? 7 : index
        index = index < 0 ? 0 : index
        
        let array: [UIImage] = [
            #imageLiteral(resourceName: "RecordingSignal001"),
            #imageLiteral(resourceName: "RecordingSignal002"),
            #imageLiteral(resourceName: "RecordingSignal003"),
            #imageLiteral(resourceName: "RecordingSignal004"),
            #imageLiteral(resourceName: "RecordingSignal005"),
            #imageLiteral(resourceName: "RecordingSignal006"),
            #imageLiteral(resourceName: "RecordingSignal007"),
            #imageLiteral(resourceName: "RecordingSignal008")
        ]
        self.signalValueImgView.image = array[index]
        LXFLog("更新音量 -- \(index)")
    }
}


