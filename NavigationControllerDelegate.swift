//
//  NavigationControllerDelegate.swift
//  αBaro
//
//  Created by Leon on 2/25/16.
//  Copyright © 2016 Ethereo. All rights reserved.
//

import UIKit

class NavigationControllerDelegate: NSObject, UINavigationControllerDelegate {
    
    
    func navigationController(navigationController: UINavigationController,
        animationControllerForOperation operation: UINavigationControllerOperation,
        fromViewController fromVC: UIViewController,
        toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            return CircleTransitionAnimator()
    }

}
