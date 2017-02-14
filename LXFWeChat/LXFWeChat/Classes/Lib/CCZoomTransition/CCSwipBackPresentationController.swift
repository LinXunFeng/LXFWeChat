//
//  CCSwipBackPresentationController.swift
//  CCGitHubPro
//
//  Created by bo on 22/12/2016.
//  Copyright © 2016 bo. All rights reserved.
//

import UIKit

//provider pan swipbackable interactionTransitioning

class CCSwipBackPresentationController: UIPresentationController {
    private(set) var swipBackTransitioning: UIPercentDrivenInteractiveTransition? = nil
    
    func edgePan(panGes : UIScreenEdgePanGestureRecognizer) {
        if let container = panGes.view {
            switch panGes.state {
            case .began:
                if (!self.presentedViewController.cc_swipeBackDisabled &&
                    nil == self.swipBackTransitioning &&
                    !self.presentingViewController.isBeingPresented &&
                    !self.presentedViewController.isBeingDismissed) {
                    self.swipBackTransitioning = UIPercentDrivenInteractiveTransition()
                    self.swipBackTransitioning?.completionCurve = .easeOut
                    self.presentingViewController.dismiss(animated: true, completion: nil)
                }
                
            case .changed:
                let translation = panGes.translation(in: container)
                var width : CGFloat = container.bounds.width
                if (width <= 0) { width = 300 }
                let d = translation.x > 0 ? (translation.x / width) : 0
                self.swipBackTransitioning?.update(d)
                
            case .ended, .cancelled, .failed:
                if (nil != self.swipBackTransitioning) {
                    if (panGes.velocity(in: container).x > 0 || self.swipBackTransitioning!.percentComplete > 0.5) {
                        self.swipBackTransitioning?.finish()
                    } else {
                        self.swipBackTransitioning?.cancel()
                    }
                    self.swipBackTransitioning = nil
                }
                
            default:
                return
            }
        }
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
        
        let ges = UIScreenEdgePanGestureRecognizer.init(target: self, action: #selector(self.edgePan(panGes:)))
        ges.edges = UIRectEdge.left
        self.containerView?.addGestureRecognizer(ges)
        
    }
}
