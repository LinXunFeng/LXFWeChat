//
//  CCZoomTransitionVCExtension.swift
//  CCGitHubPro
//
//  Created by bo on 22/12/2016.
//  Copyright © 2016 bo. All rights reserved.
//

import UIKit

extension UIViewController {
    
    //set the  presented viewController,
    //originalView: Which being tap in presenting view
    public func cc_setZoomTransition(originalView : UIView) {
        self.modalPresentationStyle = .custom
        self.modalPresentationCapturesStatusBarAppearance = true
        let transitioner = CCZoomTransitioner()
        transitioner.transitOriginalView = originalView
        self.cc_transitioner = transitioner
        self.transitioningDelegate = self.cc_transitioner
    }
    
    public var cc_swipeBackDisabled : Bool {
        get {
            if let trans = self.cc_transitioner {
                return trans.swipeBackDisabled
            } else {
                return false
            }
        }
        
        set {
            self.cc_transitioner?.swipeBackDisabled = newValue
        }
    }
    
    
    private struct AssociatedKey {
        static var ZoomTransitioner = "cc_zoomTransitioner"
    }
    
    private var cc_transitioner : CCZoomTransitioner?{
        get {
            if let transitioner = objc_getAssociatedObject(self, &AssociatedKey.ZoomTransitioner) as? CCZoomTransitioner {
                return transitioner
            } else {
                return nil
            }
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKey.ZoomTransitioner, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    
}
