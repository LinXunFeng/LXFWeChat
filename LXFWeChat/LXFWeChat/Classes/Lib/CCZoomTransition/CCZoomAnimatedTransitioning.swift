//
//  CCZoomAnimatedTransitioning.swift
//  CCGitHubPro
//
//  Created by bo on 22/12/2016.
//  Copyright © 2016 bo. All rights reserved.
//

import UIKit

//AnimatedTransitioning,Looks like to open the APP system effect

class CCZoomAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    //which view being touch in fromeVC， Need to get this view to running the animation
    var transitOriginalView : UIView? = nil
    
    var isPresentation : Bool = true
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let animateComplete = {
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        var fromVC : UIViewController
        var toVC : UIViewController
        
        if let vc = transitionContext.viewController(forKey:.from) {
            fromVC = vc
        } else {
            animateComplete()
            return
        }
        
        if let vc = transitionContext.viewController(forKey:.to) {
            toVC = vc
        } else {
            animateComplete()
            return
        }
        
        let fromView = fromVC.view!
        let toView = toVC.view!
        
        let containerView = transitionContext.containerView
        let toFrame : CGRect = {
            var frame = transitionContext.finalFrame(for:toVC)
            
            if frame.isEmpty {
                frame = containerView.frame
            }
            
            return frame
        }()
        
        toView.frame = toFrame
        
        //Obtain original view which in presentingView
        let transitview = (self.transitOriginalView ?? (self.isPresentation ? fromView : toView))!
        
        let originrect = containerView.convert(transitview.frame, from: transitview.superview)
        
        let shadow = UIImageView();
        
        //Generate the image for original view，used in animation
        var transitimage : UIImage? = nil;
        if transitview is UIImageView {
            let imagev = transitview as! UIImageView
            transitimage = imagev.image
        } else {
            transitimage = self.snapshotView(view: transitview)
        }
        
        if (self.isPresentation)
        {
            let tranimage : UIImage = {
                if let image  = self.snapshotView(view: toView) {
                    return image
                } else {
                    return self.imageWithColor(color: UIColor.init(white: 0.3, alpha: 0.3)) ?? UIImage()
                }
            }()
            
            let savetoViewalpha = toView.alpha
            toView.alpha = 0;
            containerView.addSubview(toView)
            
            shadow.frame = originrect;
            shadow.backgroundColor = UIColor.clear;
            containerView.addSubview(shadow)
            
            let blurshadow = UIImageView.init(image: tranimage)
            blurshadow.contentMode = .scaleToFill;
            blurshadow.frame = shadow.bounds;
            blurshadow.alpha = 0;
            shadow.addSubview(blurshadow)
            
            let transitvshadow = UIImageView.init(image: transitimage)
            transitvshadow.contentMode = .scaleAspectFill;
            transitvshadow.frame = shadow.bounds;
            shadow.addSubview(transitvshadow)
            shadow.clipsToBounds = true;
            
            let savetransitviewhidden = transitview.isHidden;
            transitview.isHidden = true;
            
            UIView.animateKeyframes(withDuration: self.transitionDuration(using: transitionContext),
                                    delay: 0,
                                    options: .calculationModeCubic,
                                    animations: {
                                        //shadow
                                        UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
                                            shadow.frame = containerView.bounds;
                                            blurshadow.frame = shadow.bounds;
                                            transitvshadow.frame = shadow.bounds;
                                        })
                                        
                                        UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                                            transitvshadow.alpha = 0;
                                            blurshadow.alpha = 1;
                                        })
                                        
                                        UIView.addKeyframe(withRelativeStartTime: 0.9, relativeDuration: 1, animations: {
                                            toView.alpha = 1
                                        })
                                        
            },
                                    completion: { (finish) in
                                        UIView.animateKeyframes(withDuration: 0.2, delay: 0, options: .calculationModeCubic,
                                                                animations: {
                                                                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1,
                                                                                       animations: {
                                                                                        blurshadow.alpha = 0
                                                                    })
                                        },
                                                                completion: { (finish) in
                                                                    shadow.removeFromSuperview()
                                                                    toView.alpha = savetoViewalpha
                                                                    transitview.isHidden = savetransitviewhidden
                                                                    animateComplete()
                                        })
            })
            
        }
        else
        {
            
            shadow.frame = fromView.frame;
            containerView.addSubview(shadow)
            
            shadow.backgroundColor = UIColor.clear;
            
            let transitvshadow : UIImageView = {
                let imageview = UIImageView.init(image: transitimage)
                imageview.contentMode = .scaleAspectFill
                imageview.alpha = 1
                imageview.frame = shadow.bounds
                return imageview
            }()
            shadow.addSubview(transitvshadow)
            shadow.clipsToBounds = true
            
            let fromvshadow : UIImageView = {
                let imageview = UIImageView.init(image: self.snapshotView(view: fromView))
                imageview.contentMode = .scaleToFill
                imageview.frame = shadow.bounds
                return imageview
            }()
            shadow.addSubview(fromvshadow)
            
            let savefromviewalpha = fromView.alpha
            fromView.alpha = 0
            
            let savetransitviewalpha = transitview.alpha
            transitview.alpha = 0;
            
            UIView.animateKeyframes(withDuration: self.transitionDuration(using: transitionContext),
                                    delay: 0,
                                    options: .calculationModeLinear,
                                    animations: {
                                        UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1,
                                                           animations: {
                                                            shadow.frame = originrect;
                                                            transitvshadow.frame = shadow.bounds;
                                                            fromvshadow.frame = shadow.bounds;
                                        })
                                        
                                        UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.7,
                                                           animations: {
                                                            fromvshadow.alpha = 0.8
                                        })
                                        
                                        UIView.addKeyframe(withRelativeStartTime: 0.7, relativeDuration: 0.8,
                                                           animations: {
                                                            fromvshadow.alpha = 0.1;
                                        })
                                        
                                        UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 1,
                                                           animations: {
                                                            transitvshadow.alpha = 1;
                                                            transitview.alpha = savetransitviewalpha;
                                        })
                                        
                                        
            },
                                    completion: { (finish) in
                                        shadow.removeFromSuperview()
                                        transitview.alpha = savetransitviewalpha;
                                        fromView.alpha = savefromviewalpha;
                                        animateComplete()
            })
        }
    }

}

//supper func
extension CCZoomAnimatedTransitioning {
    
    func snapshotView(view : UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        if let context = UIGraphicsGetCurrentContext() {
            view.layer.render(in: context)
            let retImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return retImage
        }
        
        return nil
    }
    
    func imageWithColor(color : UIColor) -> UIImage? {
        let size = CGSize.init(width: 1, height: 1)
        UIGraphicsBeginImageContext(size);
        let context = UIGraphicsGetCurrentContext();
        context?.setFillColor(color.cgColor)
        context?.fill(CGRect.init(origin: CGPoint.zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image
    }
    
}
