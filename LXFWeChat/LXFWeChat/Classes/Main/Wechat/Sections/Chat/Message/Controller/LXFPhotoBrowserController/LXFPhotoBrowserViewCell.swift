//
//  LXFPhotoBrowserViewCell.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2017/1/7.
//  Copyright © 2017年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import UIKit

protocol LXFPhotoBrowserViewCellDelegate : NSObjectProtocol {
    func imageViewClick()
}

class LXFPhotoBrowserViewCell: UICollectionViewCell {
    // MARK:- 属性
    var currentScale = 1.0
    // MARK: 模型
    var msgModel: LXFChatMsgModel? {
        didSet {
            setMsgModel()
        }
    }
    // MARK: 代理
    weak var delegate: LXFPhotoBrowserViewCellDelegate?
    
    // MARK: 懒加载
    lazy var imageView: UIImageView = UIImageView()
    fileprivate lazy var scrollView : UIScrollView = UIScrollView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 初始化
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK:- 初始化
extension LXFPhotoBrowserViewCell {
    // MARK:- 初始
    fileprivate func setup() {
        // 添加控件
        contentView.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.delegate = self
        
        // 设置scrollView
        scrollView.frame = contentView.bounds
        scrollView.zoomScale = 1.0
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 3
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        // 设置imageView
        imageView.frame = self.bounds
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.isMultipleTouchEnabled = true
        
        // 添加手势
        addGestrue()
    }
    
    // MARK: 添加手势
    fileprivate func addGestrue() {
        // 点击
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap(_ :)))
        // 双击
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_ :)))
        // 二指
        let twoFingerTap = UITapGestureRecognizer(target: self, action: #selector(handleTwoFingerTap(_ :)))
        
        singleTap.numberOfTapsRequired = 1
        singleTap.numberOfTouchesRequired = 1
        doubleTap.numberOfTapsRequired = 2  // 需要点两下
        twoFingerTap.numberOfTouchesRequired = 2 // 需要两个手指touch
        
        // 添加手势
        imageView.addGestureRecognizer(singleTap)
        imageView.addGestureRecognizer(doubleTap)
        imageView.addGestureRecognizer(twoFingerTap)
        singleTap.require(toFail: doubleTap) // 如果双击了，则不响应单击事件
        
        scrollView.setZoomScale(1, animated: false)
    }
}

// MARK:- 手势事件
extension LXFPhotoBrowserViewCell {
    // MARK: 单击
    @objc fileprivate func handleSingleTap(_ gesture: UITapGestureRecognizer) {
        LXFLog("单击")
        if gesture.numberOfTapsRequired == 1 {
            delegate?.imageViewClick()
        }
    }
    // MARK: 双击
    @objc fileprivate func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        LXFLog("双击")
        if gesture.numberOfTapsRequired == 2 {
            var newScale: CGFloat = 1.0
            if scrollView.zoomScale <= 1.0 {
                newScale = scrollView.zoomScale * 2.0
            } else {
                newScale = scrollView.zoomScale / 2.0
            }
            let zoomRect = self.zoomRectForScale(newScale, center: gesture.location(in: gesture.view))
            scrollView.zoom(to: zoomRect, animated: true)
        }
    }
    // MARK: 两指
    @objc fileprivate func handleTwoFingerTap(_ gesture: UITapGestureRecognizer) {
        LXFLog("两指操作")
        let newScale = scrollView.zoomScale * 0.5
        let zoomRect = self.zoomRectForScale(newScale, center: gesture.location(in: gesture.view))
        scrollView.zoom(to: zoomRect, animated: true)
    }
}

// MARK:- UIScrollViewDelegate
extension LXFPhotoBrowserViewCell : UIScrollViewDelegate {
    // 返回要缩放的图片
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    // 重新确定缩放完后的缩放倍数
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        scrollView.setZoomScale(scale + 0.01, animated: false)
        scrollView.setZoomScale(scale, animated: false)
    }
}
// MARK:- 缩放大小获取方法
extension LXFPhotoBrowserViewCell {
    func zoomRectForScale(_ scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect: CGRect = CGRect.zero
        // 大小
        zoomRect.size.height = scrollView.frame.size.height / scale
        zoomRect.size.width = scrollView.frame.size.width / scale
        // 原点
        zoomRect.origin.x = center.x - zoomRect.size.width / 2
        zoomRect.origin.y = center.y - zoomRect.size.height / 2
        return zoomRect
    }
}

// MARK:- 设置模型数据
extension LXFPhotoBrowserViewCell {
    fileprivate func setMsgModel() {
        guard let msgModel = msgModel else {
            return
        }
        
        // 设置图片
        imageView.kf.setImage(with: URL(string: msgModel.thumbUrl ?? ""))
        
    }
}
