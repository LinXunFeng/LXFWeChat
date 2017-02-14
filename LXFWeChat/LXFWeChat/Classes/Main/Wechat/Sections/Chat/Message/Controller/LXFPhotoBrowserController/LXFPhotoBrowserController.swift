//
//  LXFPhotoBrowserController.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2017/1/7.
//  Copyright © 2017年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import UIKit

fileprivate let LXFPhotoBrowserViewCellID = "LXFPhotoBrowserViewCellID"

class LXFPhotoBrowserController: UIViewController {
    // MARK:- 定义属性
    var indexPath: IndexPath!
    var picsBlock: (()->())?
    
    // MARK:- 懒加载
    lazy var msgModels: [LXFChatMsgModel] = [LXFChatMsgModel]()
    lazy var checkButton: UIButton = {
        let checkBtn = UIButton()
        checkBtn.setTitle("查看原图", for: .normal)
        checkBtn.backgroundColor = UIColor.black
        checkBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13.0)
        checkBtn.layer.borderColor = UIColor.white.withAlphaComponent(0.7).cgColor
        checkBtn.layer.borderWidth = 0.3
        checkBtn.layer.cornerRadius = 2
        checkBtn.layer.masksToBounds = true
        checkBtn.addTarget(self, action: #selector(checkButtonClick), for: .touchUpInside)
        return checkBtn
    }()
    lazy var picsButton: UIButton = {
        let picsBtn = UIButton()
        picsBtn.setImage(#imageLiteral(resourceName: "player_mode_video_wall"), for: .normal)
        picsBtn.layer.borderColor = UIColor.white.withAlphaComponent(0.7).cgColor
        picsBtn.layer.borderWidth = 0.3
        picsBtn.layer.cornerRadius = 2
        picsBtn.layer.masksToBounds = true
        picsBtn.addTarget(self, action: #selector(picsButtonClick), for: .touchUpInside)
        return picsBtn
    }()
    
    // MARK:- 懒加载属性
    lazy var collectionView : UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: LXFPhotoBrowserCollectionViewLayout())

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化
        setup()
        
        // 滚到对应的图片位置
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    // MARK:- init
    init(indexPath: IndexPath, msgModels: [LXFChatMsgModel]) {
        super.init(nibName: nil, bundle: nil)
        
        self.indexPath = indexPath
        self.msgModels = msgModels
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- 生命周期
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    deinit {
        LXFLog("LXFPhotoBrowserController 被销毁了")
        self.removeFromParentViewController()
    }
}

// MARK:- 初始化
extension LXFPhotoBrowserController {
    fileprivate func setup() {
        automaticallyAdjustsScrollViewInsets = false
        
        // 添加子控件
        view.addSubview(collectionView)
        view.addSubview(checkButton)
        view.addSubview(picsButton)
        
        // 设置frame
        collectionView.frame = view.bounds
        setCheckBtnConstraints(modelNum: indexPath.item)
        picsButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top).offset(30)
            make.right.equalTo(self.view.snp.right).offset(-10)
            make.width.equalTo(38)
            make.height.equalTo(24)
        }
        
        // 设置collectiionView属性
        collectionView.register(LXFPhotoBrowserViewCell.self, forCellWithReuseIdentifier: LXFPhotoBrowserViewCellID)
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    
    fileprivate func setCheckBtnConstraints(modelNum: Int) {
        let size = LXFSpaceSizeTools.shared.getSizeString(size: Int(msgModels[Int(modelNum)].fileLength!))
        checkButton.setTitle("查看原图\(size)", for: .normal)
        checkButton.titleLabel?.sizeToFit()
        let titleL = checkButton.titleLabel!
        checkButton.snp.remakeConstraints { (make) in
            make.centerX.equalTo(self.view.snp.centerX)
            make.bottom.equalTo(self.view.snp.bottom).offset(-20)
            make.width.equalTo(titleL.width + 8)
            make.height.equalTo(titleL.height + 5)
        }
    }
}

// MARK:- 事件处理
extension LXFPhotoBrowserController {
    func checkButtonClick() {
        LXFLog("查看原图")
    }
    func picsButtonClick() {
        LXFLog("查看附件")
        
        
        let photoListVC = LXFPhotoListController(models: msgModels)
        self.navigationController?.pushViewController(photoListVC, animated: true)
    }
}

// MARK:- UICollectionViewDataSource
extension LXFPhotoBrowserController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return msgModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = msgModels[indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LXFPhotoBrowserViewCellID, for: indexPath) as! LXFPhotoBrowserViewCell
        
        cell.msgModel = model
        cell.delegate = self
        
        return cell
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        checkButton.isHidden = true
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        checkButton.isHidden = false
        let num =  scrollView.contentOffset.x / (UIScreen.main.bounds.width + 20)
        setCheckBtnConstraints(modelNum: Int(round(num)))
    }
}

extension LXFPhotoBrowserController: LXFPhotoBrowserViewCellDelegate {
    func imageViewClick() {
        self.dismiss(animated: true, completion: nil)
    }
}


/* ============================================================ */

// MARK:- 自定义布局
class LXFPhotoBrowserCollectionViewLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        // 1.设置itemSize
        itemSize = collectionView!.frame.size
        minimumLineSpacing = 0                          // 设置最小行间距
        minimumInteritemSpacing = 0                     // 设置最小item间距
        scrollDirection = .horizontal                   // 设置滚动方向
        
        // 2.设置collectionView的属性
        collectionView?.isPagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
    }
}
