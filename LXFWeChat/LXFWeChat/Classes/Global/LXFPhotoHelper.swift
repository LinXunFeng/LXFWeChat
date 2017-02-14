//
//  LXFPhotoHelper.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2017/2/3.
//  Copyright © 2017年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import UIKit

typealias LXFPhotoHelperBlock = (_ data: Any?) -> Void

class LXFPhotoHelper: UIImagePickerController {
    
    lazy var helper: LXFPhotoDelegateHelper = {
        return LXFPhotoDelegateHelper()
    }()
    
    class func create(with sourceType: UIImagePickerControllerSourceType) -> LXFPhotoHelper {
        let picker = LXFPhotoHelper()
        picker.delegate = picker.helper
        picker.sourceType = sourceType
        return picker
    }
    
    override func viewDidLoad() {
        navigationBar.barStyle = .black
        navigationBar.barTintColor = kNavBarBgColor
    }
}

extension LXFPhotoHelper {
    func showSelectedImage(photoHeler block: @escaping LXFPhotoHelperBlock) {
        self.helper.selectedImageBlock = block
        UIApplication.shared.keyWindow?.rootViewController?.present(self, animated: true, completion: nil)
    }
}


class LXFPhotoDelegateHelper: UIViewController {
    var selectedImageBlock: (LXFPhotoHelperBlock)?
}

extension LXFPhotoDelegateHelper: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let mediaType = info["UIImagePickerControllerMediaType"] as? String else {
            return
        }
        if mediaType == String(kUTTypeImage) {
            var theImage: UIImage? = nil
            // 判断图片是否允许修改
            if picker.allowsEditing {
                theImage = info["UIImagePickerControllerEditedImage"] as? UIImage
            } else {
                theImage = info["UIImagePickerControllerOriginalImage"] as? UIImage
            }
            // 回调
            if selectedImageBlock != nil {
                selectedImageBlock!(theImage)
            }
        } else if mediaType == String(kUTTypeMovie) {
            // 获取视频文件的url
            let mediaURL = info["UIImagePickerControllerMediaURL"] as? URL
            // 回调
            if selectedImageBlock != nil {
                selectedImageBlock!(mediaURL)
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

