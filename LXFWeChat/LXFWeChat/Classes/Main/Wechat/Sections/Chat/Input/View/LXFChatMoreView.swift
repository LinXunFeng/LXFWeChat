//
//  LXFChatMoreView.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2017/1/1.
//  Copyright © 2017年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import UIKit

enum LXFChatMoreType: Int {
    case pic        // 照片
    case camera     // 相机
    case sight      // 小视频
    case video      // 视频聊天
    case wallet     // 红包
    case pay        // 转账
    case location   // 位置
    case myfav      // 收藏
    case friendCard // 个人名片
    case voiceInput // 语音输入
    case coupons    // 卡券
}

fileprivate let kMoreCellNumberOfOneRow = 4
fileprivate let kMoreCellRow = 2
fileprivate let kMoreCellNumberOfOnePage = kMoreCellRow * kMoreCellNumberOfOneRow
fileprivate let kMoreCellID = "moreCellID"

protocol LXFChatMoreViewDelegate : NSObjectProtocol {
    func chatMoreView(moreView: LXFChatMoreView, didSeletedType type: LXFChatMoreType)
}

class LXFChatMoreView: UIView {
    // MARK:- 代理
    weak var delegate: LXFChatMoreViewDelegate?
    
    // MARK:- 懒加载
    lazy var moreView: UICollectionView = { [unowned self] in
        let collectionV = UICollectionView(frame: CGRect.zero, collectionViewLayout: LXFChatHorizontalLayout(column: kMoreCellNumberOfOneRow, row: kMoreCellRow))
        collectionV.backgroundColor = kChatKeyboardBgColor
        collectionV.dataSource = self
        collectionV.delegate = self
        return collectionV
    }()

    lazy var pageControl: UIPageControl = { [unowned self] in
        let pageC = UIPageControl()
        pageC.numberOfPages = self.moreDataSouce.count / kMoreCellNumberOfOnePage + (self.moreDataSouce.count % kMoreCellNumberOfOnePage == 0 ? 0 : 1)
        pageC.currentPage = 0
        pageC.pageIndicatorTintColor = UIColor.lightGray
        pageC.currentPageIndicatorTintColor = UIColor.gray
        return pageC
    }()
    
    lazy var moreDataSouce: [(name: String, icon: UIImage, type: LXFChatMoreType)] = {
        return [
            ("照片", #imageLiteral(resourceName: "sharemore_pic"), LXFChatMoreType.pic),
            ("相机", #imageLiteral(resourceName: "sharemore_video"), LXFChatMoreType.camera),
            ("小视频", #imageLiteral(resourceName: "sharemore_sight"), LXFChatMoreType.sight),
            ("视频聊天", #imageLiteral(resourceName: "sharemore_videovoip"), LXFChatMoreType.video),
            ("红包", #imageLiteral(resourceName: "sharemore_wallet"), LXFChatMoreType.wallet),
            ("转账", #imageLiteral(resourceName: "sharemorePay"), LXFChatMoreType.pay),
            ("位置", #imageLiteral(resourceName: "sharemore_location"), LXFChatMoreType.location),
            ("收藏", #imageLiteral(resourceName: "sharemore_myfav"), LXFChatMoreType.myfav),
            ("个人名片", #imageLiteral(resourceName: "sharemore_friendcard"), LXFChatMoreType.friendCard),
            ("语音输入", #imageLiteral(resourceName: "sharemore_voiceinput"), LXFChatMoreType.voiceInput),
            ("卡券", #imageLiteral(resourceName: "sharemore_wallet"), LXFChatMoreType.coupons)
        ]
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addSubview(moreView)
        self.addSubview(pageControl)
        
        moreView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(self)
            make.height.equalTo(197)
        }
        
        pageControl.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.height.equalTo(35)
            make.bottom.equalTo(self.snp.bottom)
        }
        self.backgroundColor = kChatKeyboardBgColor
        moreView.contentSize = CGSize(width: kScreenW * 2, height: moreView.height)
        // 注册itemID
        moreView.register(LXFChatMoreCell.self, forCellWithReuseIdentifier: kMoreCellID)
        
    }
}

extension LXFChatMoreView : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moreDataSouce.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let moreModel = moreDataSouce[indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kMoreCellID, for: indexPath) as? LXFChatMoreCell
        
        cell?.model = moreModel
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let moreModel = moreDataSouce[indexPath.item]
        LXFLog(moreModel)
        delegate?.chatMoreView(moreView: self, didSeletedType: moreModel.type)
    }
    
}
extension LXFChatMoreView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.x
        let page = contentOffset / scrollView.frame.size.width + (Int(contentOffset) % Int(scrollView.frame.size.width) == 0 ? 0 : 1)
        pageControl.currentPage = Int(page)
    }
}
