//
//  LXFChatEmotionView.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2017/1/1.
//  Copyright © 2017年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import UIKit

fileprivate let kEmotionCellNumberOfOneRow = 8
fileprivate let kEmotionCellRow = 3
fileprivate let kEmotionCellNumberOfOnePage = kEmotionCellRow * kEmotionCellNumberOfOneRow
fileprivate let kEmotionViewHeight: CGFloat = 160.0
fileprivate let kEmotionCellID = "emotionCellID"

protocol LXFChatEmotionViewDelegate: NSObjectProtocol {
    func chatEmotionView(emotionView: LXFChatEmotionView, didSelectedEmotion emotion: LXFChatEmotion)
    func chatEmotionViewSend(emotionView: LXFChatEmotionView)
}

class LXFChatEmotionView: UIView {
    // MARK:- 定义属性
    lazy var emotions: [LXFChatEmotion] = {
        return LXFChatEmotionHelper.getAllEmotions()
    }()
    
    // MARK:- 代理
    weak var delegate: LXFChatEmotionViewDelegate?
    
    // MARK:- 懒加载
    lazy var bottomView: UIView = { [unowned self] in
        let bottomV = UIView()
        bottomV.backgroundColor = UIColor.white
        bottomV.addSubview(self.addButton)
        bottomV.addSubview(self.emotionButton)
        bottomV.addSubview(self.sendButton)
        return bottomV
    }()
    
    lazy var addButton: UIButton = {
        let addBtn = UIButton(type: .custom)
        addBtn.backgroundColor = UIColor.white
        addBtn.addTarget(self, action: #selector(addBtnClick(_:)), for: .touchUpInside)
        addBtn.setImage(#imageLiteral(resourceName: "Card_AddIcon"), for: .normal)
        return addBtn
    }()
    
    lazy var sendButton: UIButton = { [unowned self] in
        let sendBtn = UIButton(type: .custom)
        sendBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        sendBtn.backgroundColor = UIColor(red:0.13, green:0.41, blue:0.79, alpha:1.00)
        sendBtn.setTitle("发送", for: .normal)
        sendBtn.addTarget(self, action: #selector(sendBtnClick(_:)), for: .touchUpInside)
        return sendBtn
    }()
    
    lazy var emotionButton: UIButton = {
        let emotionBtn = UIButton(type: .custom)
        emotionBtn.backgroundColor = kChatKeyboardBgColor
        emotionBtn.addTarget(self, action: #selector(emotionBtnClick(_:)), for: .touchUpInside)
        emotionBtn.setImage(#imageLiteral(resourceName: "EmotionsEmojiHL"), for: .normal)
        return emotionBtn
    }()
    
    lazy var pageControl: UIPageControl = { [unowned self] in
        let pageC = UIPageControl()
        pageC.numberOfPages = self.emotions.count / kEmotionCellNumberOfOnePage + (self.emotions.count % kEmotionCellNumberOfOnePage == 0 ? 0 : 1)
        pageC.currentPage = 0
        pageC.pageIndicatorTintColor = UIColor.lightGray
        pageC.currentPageIndicatorTintColor = UIColor.gray
        pageC.backgroundColor = kChatKeyboardBgColor
        return pageC
    }()
    
    lazy var emotionView: UICollectionView = { [unowned self] in
        let collectV = UICollectionView(frame: CGRect.zero, collectionViewLayout: LXFChatHorizontalLayout(column: kEmotionCellNumberOfOneRow, row: kEmotionCellRow))
        collectV.backgroundColor = kChatKeyboardBgColor
        collectV.isPagingEnabled = true
        collectV.dataSource = self
        collectV.delegate = self
        return collectV
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.addSubview(bottomView)
        self.addSubview(emotionView)
        self.addSubview(pageControl)
        
        // 布局
        bottomView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(38)
        }
        addButton.snp.makeConstraints { (make) in
            make.top.left.bottom.equalTo(bottomView)
            make.width.equalTo(45)
        }
        emotionButton.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(bottomView)
            make.left.equalTo(addButton.snp.right)
            make.width.equalTo(45)
        }
        sendButton.snp.makeConstraints { (make) in
            make.top.right.bottom.equalTo(bottomView)
            make.width.equalTo(53)
        }
        emotionView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(self)
            make.height.equalTo(160)
        }
        pageControl.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(emotionView.snp.bottom).offset(-6)
            make.bottom.equalTo(bottomView.snp.top)
        }
        
        // 注册emotionCell
        emotionView.register(LXFChatEmotionCell.self, forCellWithReuseIdentifier: kEmotionCellID)
    }
}

extension LXFChatEmotionView {
    func addBtnClick(_ btn: UIButton) {
        LXFLog("添加表情")
    }
    func emotionBtnClick(_ btn: UIButton) {
        LXFLog("自带表情")
    }
    func sendBtnClick(_ btn: UIButton) {
        LXFLog("发送")
        delegate?.chatEmotionViewSend(emotionView: self)
    }
}

extension LXFChatEmotionView : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emotions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let emo = emotions[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kEmotionCellID, for: indexPath) as? LXFChatEmotionCell
        cell?.emotion = emo
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let emo = emotions[indexPath.item]
        delegate?.chatEmotionView(emotionView: self, didSelectedEmotion: emo)
    }
}
extension LXFChatEmotionView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.x
        let page = contentOffset / scrollView.frame.size.width + (Int(contentOffset) % Int(scrollView.frame.size.width) == 0 ? 0 : 1)
        pageControl.currentPage = Int(page)
    }
}
