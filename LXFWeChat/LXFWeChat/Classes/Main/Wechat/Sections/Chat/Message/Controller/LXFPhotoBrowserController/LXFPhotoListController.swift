//
//  LXFPhotoListController.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2017/1/9.
//  Copyright © 2017年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import UIKit

private let LXFPhotoListCellID = "LXFPhotoListCellID"

class LXFPhotoListController: UIViewController {
    // MARK:- 记录属性
    var models = [LXFChatMsgModel]()
    
    // MARK:- 懒加载属性
    lazy var collectionView : UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: LXFPhotoListControllerViewLayout())

    // MARK:- init
    init(models: [LXFChatMsgModel]) {
        super.init(nibName: nil, bundle: nil)
        self.models = models
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.red
        // 初始化
        self.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
}

// MARK:- 初始化
extension LXFPhotoListController {
    fileprivate func setup() {
        // 设置标题
        title = "聊天文件"
        
        // 添加子控件
        view.addSubview(collectionView)
        
        // 设置frame
        collectionView.frame = view.frame
        
        // 设置collectiionView属性
        collectionView.backgroundColor = RGBA(r: 0.18, g: 0.19, b: 0.20, a: 1.00)
        collectionView.register(LXFPhotoListCell.self, forCellWithReuseIdentifier: LXFPhotoListCellID)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}


// MARK:- UICollectionViewDataSource && UICollectionViewDelegate
extension LXFPhotoListController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = models[indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LXFPhotoListCellID, for: indexPath) as! LXFPhotoListCell
        
        cell.imgView.kf.setImage(with: URL(string: model.thumbUrl ?? ""))
        
        return cell
    }
    
}

// MARK:- 自定义布局
class LXFPhotoListControllerViewLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        let margin: CGFloat = 5
        let lineSpacing: CGFloat = 10
        
        // 1.设置itemSize
        let itemWH: CGFloat = (kScreenW - 4 * 10) / 3
        itemSize = CGSize(width: itemWH, height: itemWH)
        minimumLineSpacing = lineSpacing                          // 设置最小行间距
        minimumInteritemSpacing = 0                     // 设置最小item间距
        scrollDirection = .vertical                   // 设置滚动方向
        
        // 2.设置collectionView的属性
        collectionView?.contentInset = UIEdgeInsetsMake(64 + lineSpacing, margin, 0, margin)
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
    }
}
