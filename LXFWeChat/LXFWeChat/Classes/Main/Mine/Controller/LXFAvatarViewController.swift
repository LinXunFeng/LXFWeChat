//
//  LXFAvatarViewController.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2017/1/31.
//  Copyright © 2017年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import UIKit

class LXFAvatarViewController: LXFBaseController {
    // MARK:- 懒加载
    lazy var imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.frame = CGRect(x: 0, y: (kScreenH - kScreenW + 64) * 0.5, width: kScreenW, height: kScreenW)
        
        let avatarUrl = LXFWeChatTools.shared.getMineInfo()?.userInfo?.avatarUrl
        if avatarUrl != nil {
            imgView.kf.setImage(with: URL(string: avatarUrl!))
        } else {
            imgView.image = #imageLiteral(resourceName: "SettingProfileHead")
        }
        return imgView
    }()
    

    // MARK:- 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化
        self.setup()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension LXFAvatarViewController {
    fileprivate func setup() {
        // 设置标题
        navigationItem.title = "个人头像"
        
        // 右上角图标
        self.createRightBarBtnItem(icon: #imageLiteral(resourceName: "barbuttonicon_more"), method: #selector(more))
        
        // 注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(goBack(_:)), name: NSNotification.Name(rawValue: kNoteWeChatGoBack), object: nil)
        
        view.backgroundColor = UIColor.black
        view.addSubview(imgView)
    }
}

// MARK:- 事件处理
extension LXFAvatarViewController {
    @objc fileprivate func more() {
        let sheet = LXFActionSheet(delegate: self, cancelTitle: "取消", otherTitles: ["拍照", "从手机相册选择", "保存图片"])
        sheet.show()
    }
    
    @objc fileprivate func goBack(_ note: Notification) {
        guard let type = note.object as? LXFWeChatToolsUpdateType else {
            return
        }
        if type == .avatar {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
}

// MARK:- LXFActionSheetDelegate
extension LXFAvatarViewController: LXFActionSheetDelegate {
    func lxfActionSheet(actionSheet: LXFActionSheet, didClickedAt index: Int) {
        switch index {
        case 0:
            LXFLog("拍照")
            LXFPhotoHelper.create(with: .camera).showSelectedImage(photoHeler: { (data) in
                LXFLog("拍照 --- \(data)")
            })
        case 1:
            LXFLog("从手机相册选择")
            LXFPhotoHelper.create(with: .photoLibrary).showSelectedImage { (data) in
                LXFLog("选择照片 --- \(data)")
                guard let img = data as? UIImage else {
                    return
                }
                LXFWeChatTools.shared.updateAvatar(with: img)
            }
        case 2:
            LXFLog("保存图片")
            guard let img = self.imgView.image else {
                break
            }
            UIImageWriteToSavedPhotosAlbum(img, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
        default:
            break
        }
    }
    
    @objc fileprivate func image(image : UIImage, didFinishSavingWithError error : NSError?, contextInfo : AnyObject) {
        if error != nil {
            LXFProgressHUD.lxf_showError(withStatus: "保存失败")
        } else {
            LXFProgressHUD.lxf_showSuccess(withStatus: "保存成功")
        }
    }
}

