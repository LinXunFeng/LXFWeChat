//
//  LXFQRCodeViewController.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2017/2/2.
//  Copyright © 2017年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import UIKit

class LXFQRCodeViewController: LXFBaseController {
    
    // MARK:- 懒加载
    lazy var qrCodeView: UIView = {
        let qrCodeView = UIView()
        qrCodeView.backgroundColor = UIColor.white
        qrCodeView.layer.cornerRadius = 2
        qrCodeView.layer.masksToBounds = true
        return qrCodeView
    }()
    
    lazy var tipLabel: UILabel = {
        let tipLabel = UILabel()
        tipLabel.text = "扫一扫上面的二维码图案，加我微信"
        tipLabel.font = UIFont.systemFont(ofSize: 11.0)
        tipLabel.textColor = UIColor.gray
        tipLabel.textAlignment = .center
        tipLabel.sizeToFit()
        return tipLabel
    }()
    
    lazy var nameLabel: UILabel  = {
        let nameLabel = UILabel()
        nameLabel.text = "LinXunFeng"
        nameLabel.font = UIFont.systemFont(ofSize: 17.0)
        nameLabel.sizeToFit()
        return nameLabel
    }()
    
    lazy var areaLabel: UILabel  = {
        let areaLabel = UILabel()
        areaLabel.text = "广东 深圳"
        areaLabel.font = UIFont.systemFont(ofSize: 12.0)
        areaLabel.textColor = UIColor.gray
        areaLabel.sizeToFit()
        return areaLabel
    }()
    
    // MARK:- 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化
        self.setup()
    }
}

// MARK:- 初始化
extension LXFQRCodeViewController {
    fileprivate func setup() {
        // 设置标题
        navigationItem.title = "我的二维码"
        
        // 右上角图标
        self.createRightBarBtnItem(icon: #imageLiteral(resourceName: "barbuttonicon_more"), method: #selector(more))
        
        // 设置背景颜色
        view.backgroundColor = RGBA(r: 0.18, g: 0.19, b: 0.20, a: 1.0)
        
        
        // 布局
        self.view.addSubview(qrCodeView)
        qrCodeView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(20)
            make.right.equalTo(self.view.snp.right).offset(-20)
            make.height.equalTo(435)
            make.centerY.equalTo(self.view.snp.centerY).offset(32)
        }
        
        // 头像
        let avatarView = UIImageView(frame: CGRect(x: 20, y: 20, width: 62, height: 62))
        avatarView.image = #imageLiteral(resourceName: "Icon")
        qrCodeView.addSubview(avatarView)
        
        qrCodeView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatarView.snp.right).offset(10)
            make.bottom.equalTo(avatarView.snp.centerY)
            
        }
        
        qrCodeView.addSubview(areaLabel)
        areaLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp.left)
            make.top.equalTo(avatarView.snp.centerY).offset(5)
        }
        
        
        // 二维码
        let qrImgView = createQRImg()
        qrCodeView.addSubview(qrImgView)
        qrImgView.snp.makeConstraints { (make) in
            make.left.equalTo(qrCodeView.snp.left).offset(35)
            make.right.equalTo(qrCodeView.snp.right).offset(-35)
            make.height.equalTo(qrImgView.snp.width)
            make.bottom.equalTo(qrCodeView.snp.bottom).offset(-60)
        }
        
        // 提示
        qrCodeView.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(qrCodeView)
            make.bottom.equalTo(qrCodeView.snp.bottom).offset(-20)
        }
        
        
    }
}

// MARK:- 事件处理
extension LXFQRCodeViewController {
    @objc fileprivate func more() {
        let sheet = LXFActionSheet(delegate: self, cancelTitle: "取消", otherTitles: ["换个样式", "保存图片", "扫描二维码"])
        sheet.show()
    }
    
    // 创建二维码
    fileprivate func createQRImg() -> UIImageView {
        let size = CGSize(width: 250, height: 250)
        let qrImg = LBXScanWrapper.createCode(codeType: "CIQRCodeGenerator", codeString: "LinXunFengLinXunFengLinXunFeng", size: size, qrColor: UIColor.black, bkColor: UIColor.white)
        let logoImg = #imageLiteral(resourceName: "Icon")
        let myQRImg = LBXScanWrapper.addImageLogo(srcImg: qrImg!, logoImg: logoImg, logoSize: CGSize(width: 65, height: 65))
        return UIImageView(image: myQRImg)
    }
}

// MARK:- LXFActionSheetDelegate
extension LXFQRCodeViewController: LXFActionSheetDelegate {
    func lxfActionSheet(actionSheet: LXFActionSheet, didClickedAt index: Int) {
        switch index {
        case 0:
            LXFLog("换个样式")
        case 1:
            LXFLog("保存图片")
            guard let img = self.qrCodeView.trans2Image() else {
                break
            }
            UIImageWriteToSavedPhotosAlbum(img, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
        case 2:
            LXFLog("扫描二维码")
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
