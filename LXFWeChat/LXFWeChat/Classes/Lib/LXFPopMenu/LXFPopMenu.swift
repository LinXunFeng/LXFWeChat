//
//  LXFPopMenu.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2016/12/26.
//  Copyright © 2016年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import UIKit

fileprivate let kLXFMenuTableViewWidth: CGFloat           = 140.0
fileprivate let kLXFMenuTableViewSapcing: CGFloat         = 7.0
fileprivate let kLXFMenuItemViewHeight: CGFloat           = 45.0
fileprivate let kLXFMenuItemViewImageSpacing: CGFloat     = 15.0
fileprivate let kLXFSeparatorLineImageViewHeight: CGFloat = 0.5

class LXFPopMenu: UIView {
    
    // MARK:- 回调
    var popMenuDidSelectedBlock: ((_ index: Int, _ menuItem: LXFPopMenuItem) -> ())?
    
    // MARK:- 懒加载
    lazy var menuContainerView: UIImageView = { [unowned self] in
        let container = UIImageView(image: #imageLiteral(resourceName: "MoreFunctionFrame").resizableImage(withCapInsets: UIEdgeInsetsMake(30, 10, 30, 50), resizingMode: .tile))
        container.isUserInteractionEnabled = true
        container.frame = CGRect(x: self.bounds.width - (kLXFMenuTableViewWidth+kLXFMenuTableViewSapcing * 2), y: 65, width: (kLXFMenuTableViewWidth+kLXFMenuTableViewSapcing * 2), height: CGFloat(self.menus?.count ?? 0) * (kLXFMenuItemViewHeight + kLXFSeparatorLineImageViewHeight) + kLXFMenuTableViewSapcing * 2)
        return container
    }()
    
    lazy var menuTableView: UITableView = { [unowned self] in
        let tableView = UITableView(frame: CGRect(x: kLXFMenuTableViewSapcing, y: kLXFMenuTableViewSapcing + 2, width: kLXFMenuTableViewWidth, height: self.menuContainerView.bounds.height - kLXFMenuTableViewSapcing), style: .plain)
        tableView.backgroundColor = UIColor.clear
        tableView.separatorColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = kLXFMenuItemViewHeight
        tableView.isScrollEnabled = false
        return tableView
    }()
    // MARK:- 属性
    weak var currentSuperView: UIView?
    var targetPoint: CGPoint?
    var indexPath: IndexPath!
    var menus: [LXFPopMenuItem]?
    
    // MARK:- 重载init
    init(menus: [LXFPopMenuItem]) {
        super.init(frame: CGRect.zero)
        self.menus = menus
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showMenu(at point: CGPoint) {
        self.showMenu(on: UIApplication.shared.keyWindow!, at: point)
    }
    
    func showMenu(on view: UIView, at point: CGPoint) {
        currentSuperView = view
        targetPoint = point
        self.showMenu()
    }
    
    fileprivate func showMenu() {
        
        guard let curSuperView = currentSuperView else {
            return
        }
        if !curSuperView.subviews.contains(self) {
            alpha = 0.0
            currentSuperView?.addSubview(self)
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: { 
                self.alpha = 1.0
            })
        } else {
            self.removeFromSuperview()
            self.dismissPopMenuAnimatedOnMenu(selected: false)
        }
    }
    
    deinit {
        LXFLog("我被销毁了")
    }
    
    func dismissPopMenuAnimatedOnMenu(selected: Bool) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: { [unowned self] in
            self.alpha = 0.0
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let localPoint = touch?.location(in: self)
        if self.menuContainerView.frame.contains(localPoint!) { 
            hitTest(localPoint!, with: event)
        } else {
            self.dismissPopMenuAnimatedOnMenu(selected: false)
        }
    }
    // 初始化
    fileprivate func setup() {
        self.frame = UIScreen.main.bounds
        self.backgroundColor = UIColor.clear
        menuContainerView.addSubview(self.menuTableView)
        self.addSubview(menuContainerView)
    }
}

// MARK:- UITableViewDelegate, UITableViewDataSource
extension LXFPopMenu: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menus?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "LXFPopViewCellID"
        var popMenuItemView = tableView.dequeueReusableCell(withIdentifier: cellID)
        if popMenuItemView == nil {
            popMenuItemView = LXFPopMenuItemView(style: .default, reuseIdentifier: cellID)
        }
        if indexPath.row < self.menus?.count ?? 0 {
            if let cell = popMenuItemView as? LXFPopMenuItemView {
                cell.setup(popMenuItem: (self.menus?[indexPath.row])!, at: indexPath, isBottom: (indexPath.row == (self.menus?.count)! - 1))
            }
        }
        return popMenuItemView!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.indexPath = indexPath
        self.dismissPopMenuAnimatedOnMenu(selected: true)
        // 回调
        if popMenuDidSelectedBlock != nil {
            popMenuDidSelectedBlock!(indexPath.row, self.menus![indexPath.row])
        }
    }
}

/* ============================ LXFPopMenuItem =============================== */
class LXFPopMenuItem: NSObject {
    var image: UIImage?
    var title: String?
    
    init(image: UIImage?, title: String?) {
        super.init()
        self.image = image
        self.title = title
    }
}

/* ============================ LXFPopMenuItemView =============================== */
class LXFPopMenuItemView: UITableViewCell {
    var popMenuItem: LXFPopMenuItem?
    lazy fileprivate var separatorLineImageView: UIImageView = { [unowned self] in
        let separatorLine = UIImageView(frame: CGRect(x: kLXFMenuItemViewImageSpacing, y: kLXFMenuItemViewHeight - kLXFSeparatorLineImageViewHeight, width: kLXFMenuTableViewWidth - 2 * kLXFMenuTableViewSapcing - 10, height: kLXFSeparatorLineImageViewHeight))
        separatorLine.backgroundColor = UIColor.init(red: 0.468, green: 0.519, blue: 0.549, alpha: 0.9)
        return separatorLine
    }()
    lazy fileprivate var menuSelectedBackgroundView: UIView = {
        let bgView = UIView(frame: self.contentView.bounds)
        bgView.autoresizingMask = .flexibleHeight
        bgView.backgroundColor = UIColor.init(red: 0.216, green: 0.242, blue: 0.263, alpha: 0.9)
        return bgView
    }()
    
    func setup(popMenuItem: LXFPopMenuItem, at IndexPath: IndexPath, isBottom: Bool) {
        self.popMenuItem = popMenuItem
        self.textLabel?.text = popMenuItem.title
        self.imageView?.image = popMenuItem.image
        self.separatorLineImageView.isHidden = isBottom
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear
        textLabel?.textColor = UIColor.white
        textLabel?.font = UIFont.systemFont(ofSize: 15)
        self.selectedBackgroundView = self.menuSelectedBackgroundView
        contentView.addSubview(separatorLineImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var textLabelFrame = textLabel?.frame
        textLabelFrame?.origin.x = (self.imageView?.frame.maxX)! + 5
        textLabel?.frame = textLabelFrame!
    }
    
    
}

