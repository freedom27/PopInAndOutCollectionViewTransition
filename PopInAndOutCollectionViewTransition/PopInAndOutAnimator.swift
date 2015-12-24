//
//  PopInAndOutAnimator.swift
//  PopInAndOutCollectionViewTransition
//
//  Created by Stefano Vettor on 15/12/15.
//  Copyright © 2015 Stefano Vettor. All rights reserved.
//

import Foundation

//
//  PushAndPopZoomAnimator.swift
//  MyTVSerials
//
//  Created by Stefano Vettor on 17/06/15.
//  Copyright (c) 2015 Stefano Vettor. All rights reserved.
//

import Foundation
import UIKit

class PopInAndOutAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let _operationType : UINavigationControllerOperation
    private let _transitionDuration : NSTimeInterval
    
    init(operation: UINavigationControllerOperation) {
        _operationType = operation
        _transitionDuration = 0.4
    }
    
    init(operation: UINavigationControllerOperation, andDuration duration: NSTimeInterval) {
        _operationType = operation
        _transitionDuration = duration
    }
    
    //MARK: Push and Pop animations performers
    internal func performPushTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toView = transitionContext.viewForKey(UITransitionContextToViewKey),
            let container = transitionContext.containerView() else {
                // Something really bad happend and it is not possible to perform the transition
                print("ERROR: Transition impossible to perform since either the destination view or the conteiner view are missing!")
                return
        }
        
        guard let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as? CollectionPushAndPoppable,
            let fromView = fromViewController.collectionView,
            let currentCell = fromViewController.sourceCell else {
                // There are not enough info to perform the animation but it is still possible
                // to perform the transition presenting the destination view
                container.addSubview(toView)
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            return
        }
        
        // Add to container the destination view
        container.addSubview(toView)
        
        // Prepare the screenshot of the destination view for animation
        let screenshotToView =  UIImageView(image: toView.screenshot)
        screenshotToView.frame = currentCell.frame
        let windowCoord = fromView.convertPoint(screenshotToView.frame.origin, toView: UIApplication.sharedApplication().keyWindow?.rootViewController?.view)
        screenshotToView.frame.origin = windowCoord
        
        // Prepare the screenshot of the source view for animation
        let screenshotFromView = UIImageView(image: currentCell.screenshot)
        screenshotFromView.frame = screenshotToView.frame
        
        // Add screenshots to transition container to set-up the animation
        container.addSubview(screenshotToView)
        container.addSubview(screenshotFromView)
        
        // Set views initial states
        toView.hidden = true
        screenshotToView.hidden = true
        
        // Delay to guarantee smooth effects
        let delayTime = dispatch_time(DISPATCH_TIME_NOW,
            Int64(0.08 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            screenshotToView.hidden = false
        }
        
        UIView.animateWithDuration(_transitionDuration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: { () -> Void in
            
            screenshotFromView.alpha = 0.0
            screenshotToView.frame = UIScreen.mainScreen().bounds
            screenshotToView.frame.origin = CGPointMake(0.0, 0.0)
            screenshotFromView.frame = screenshotToView.frame
            
            }) { _ in
                
                screenshotToView.removeFromSuperview()
                screenshotFromView.removeFromSuperview()
                toView.hidden = false
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                
        }
    }
    
    internal func performPopTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toView = transitionContext.viewForKey(UITransitionContextToViewKey),
            let container = transitionContext.containerView() else {
                // Something really bad happend and it is not possible to perform the transition
                print("ERROR: Transition impossible to perform since either the destination view or the conteiner view are missing!")
                return
        }
        
        guard let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as? CollectionPushAndPoppable,
            let toCollectionView = toViewController.collectionView,
            let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            let fromView = fromViewController.view,
            let currentCell = toViewController.sourceCell else {
                // There are not enough info to perform the animation but it is still possible
                // to perform the transition presenting the destination view
                container.addSubview(toView)
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                return
        }
        
        // Prepare the screenshot of the source view for animation
        let screenshotFromView = UIImageView(image: fromView.screenshot)
        screenshotFromView.frame = fromView.frame
        
        let offsetFromWindow = toCollectionView.convertPoint(currentCell.frame.origin, toView: toViewController.view).y
        
        // Prepare the screenshot of the destination view for animation
        let screenshotToView = UIImageView(image: currentCell.screenshot)
        screenshotToView.frame = screenshotFromView.frame
        
        // Set views initial states
        screenshotToView.alpha = 0.0
        fromView.hidden = true
        currentCell.hidden = true
        
        // Add screenshots to transition container to set-up the animation
        container.addSubview(toView)
        container.addSubview(screenshotToView)
        container.insertSubview(screenshotFromView, belowSubview: screenshotToView)
        
        UIView.animateWithDuration(_transitionDuration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: { () -> Void in
            
            screenshotToView.alpha = 1.0
            screenshotFromView.frame = currentCell.frame
            screenshotFromView.frame.origin = CGPointMake(screenshotFromView.frame.origin.x, offsetFromWindow)
            screenshotToView.frame = screenshotFromView.frame
            
            }) { _ in
                
                currentCell.hidden = false
                screenshotFromView.removeFromSuperview()
                screenshotToView.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                
        }
    }
    
    //MARK: UIViewControllerAnimatedTransitioning
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return _transitionDuration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        if _operationType == .Push {
            performPushTransition(transitionContext)
        } else if _operationType == .Pop {
            performPopTransition(transitionContext)
        }
    }
}