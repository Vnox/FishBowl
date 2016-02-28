//
//  CircleTransitionAnimator.swift
//  αBaro
//
//  Created by Leon on 2/25/16.
//  Copyright © 2016 Ethereo. All rights reserved.
//

import UIKit

class CircleTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    weak var transitionContext: UIViewControllerContextTransitioning?
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        //1
        self.transitionContext = transitionContext
        
        //2
        var containerView = transitionContext.containerView()
        var fromViewController : UIViewController!
        var toViewController : UIViewController!
        var button : UIButton
        
        if let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as? MainViewController{
            
            fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! MainViewController
            toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! shareViewController
            button = (fromViewController as! MainViewController).R2Image
        
        }else{
            
            fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! shareViewController
            toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! MainViewController
            button = (fromViewController as! shareViewController).myButton

        }
        
        //3
        containerView!.addSubview(toViewController.view)
        
        //4
        var circleMaskPathInitial = UIBezierPath(ovalInRect: button.frame)
        var extremePoint = CGPoint(x: button.center.x - 0, y: button.center.y - CGRectGetHeight(toViewController.view.bounds))
        var radius = sqrt((extremePoint.x*extremePoint.x) + (extremePoint.y*extremePoint.y)) + 400
        var circleMaskPathFinal = UIBezierPath(ovalInRect: CGRectInset(button.frame, -radius, -radius))
        
        //5
        var maskLayer = CAShapeLayer()
        maskLayer.path = circleMaskPathFinal.CGPath
        toViewController.view.layer.mask = maskLayer
        
        //6
        var maskLayerAnimation = CABasicAnimation(keyPath: "path")
        maskLayerAnimation.fromValue = circleMaskPathInitial.CGPath
        maskLayerAnimation.toValue = circleMaskPathFinal.CGPath
        maskLayerAnimation.duration = self.transitionDuration(transitionContext)
        maskLayerAnimation.delegate = self
        maskLayer.addAnimation(maskLayerAnimation, forKey: "path")
        
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        self.transitionContext?.completeTransition(!self.transitionContext!.transitionWasCancelled())
        self.transitionContext?.viewControllerForKey(UITransitionContextFromViewControllerKey)?.view.layer.mask = nil
    }
    

    
}
