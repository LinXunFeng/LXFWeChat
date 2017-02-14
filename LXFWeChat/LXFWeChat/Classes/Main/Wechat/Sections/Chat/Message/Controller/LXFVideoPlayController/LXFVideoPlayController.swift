//
//  LXFVideoPlayController.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2017/1/15.
//  Copyright © 2017年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import UIKit

class LXFVideoPlayController: UIViewController {
    
    // MARK:- 记录属性
    var videoPath: String?
    var videoSize: CGSize?
    var videoCoverUrl: String?
    var videoUrl: String?
    weak var closeBtn: UIButton?
    weak var coverImgView: UIImageView?
    
    // MARK:- 懒加载
    lazy var backButton: UIButton = {
        let backBtn = UIButton(type: .custom)
        backBtn.setImage(#imageLiteral(resourceName: "player_back_button"), for: .normal)
        return backBtn
    }()
    
    // MARK:- init
    init(model: LXFChatMsgModel) {
        super.init(nibName: nil, bundle: nil)
        
        videoPath = model.videoPath
        videoSize = model.videoCoverSize
        videoCoverUrl = model.videoCoverUrl
        videoUrl = model.videoUrl
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK:- 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化
        self.setup()
    }
}

// MARK:- 初始化
extension LXFVideoPlayController {
    // MARK: 初始化UI
    fileprivate func setup() {
        // 背景色
        view.backgroundColor = UIColor.black
        
        // 封面
        let coverH = (videoSize?.width ?? 1) * kScreenH / kScreenW
        let coverImgView = UIImageView()
        self.coverImgView = coverImgView
        coverImgView.kf.setImage(with: URL(string: videoCoverUrl ?? ""))
        view.addSubview(coverImgView)
        coverImgView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.centerY.equalTo(view.snp.centerY)
            make.height.equalTo(coverH)
        }
        
        // 添加环形进度
        let progressView = DACircularProgressView(frame: CGRect.zero)
        progressView.roundedCorners = 1
        progressView.trackTintColor = UIColor.white
        progressView.isHidden = true
        coverImgView.addSubview(progressView)
        progressView.snp.makeConstraints { (make) in
            make.width.height.equalTo(40)
            make.center.equalTo(coverImgView.snp.center)
        }
        
        view.layoutIfNeeded()
        
        // 关闭按钮
        let closeBtn = UIButton(type: .custom)
        closeBtn.setImage(#imageLiteral(resourceName: "player_back_button"), for: .normal)
        closeBtn.imageView?.contentMode = .scaleAspectFit
        closeBtn.addTarget(self, action: #selector(close), for: .touchUpInside)
        view.addSubview(closeBtn)
        closeBtn.snp.makeConstraints { (make) in
            make.top.left.equalTo(view).offset(30)
            make.width.height.equalTo(30)
        }
        
        LXFLog(videoPath)
        
        if LXFFileManager.isExists(at: videoPath ?? "") {
            // 播放视图
            addPlayer()
        } else {
            progressView.isHidden = false
            // 先下载
            LXFNetworkTools.shared.download(urlStr: videoUrl ?? "", savePath: videoPath ?? "'", progress: { (progress) in
                progressView.progress = CGFloat(progress)
            }, resultBlock: { [unowned self] (url, error) in
                progressView.isHidden = true
                if error != nil {
                    LXFLog(error)
                } else {
                    self.addPlayer()
                }
            })
        }
    }
    
    // MARK: 添加播放视图
    fileprivate func addPlayer() {
        // 播放视图
        let videoPlay = KZVideoPlayer(frame: coverImgView!.frame, videoUrl: URL(fileURLWithPath: videoPath ?? ""))!
        view.addSubview(videoPlay)
    }
    
}

// MARK:- 事件处理
extension LXFVideoPlayController {
    // 关闭
    @objc fileprivate func close() {
        self.dismiss(animated: true, completion: nil)
    }
}

