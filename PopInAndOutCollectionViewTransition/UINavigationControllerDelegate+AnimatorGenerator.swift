//
//  UINavigationControllerDelegate+AnimatorGenerator.swift
//  PopInAndOutCollectionViewTransition
//
//  Created by Stefano Vettor on 15/12/15.
//  Copyright © 2015 Stefano Vettor. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationControllerDelegate {
    
    func animatorForOperation(operation: UINavigationControllerOperation) -> UIViewControllerAnimatedTransitioning? {
        return PopInAndOutAnimator(operation: operation, andDuration: 0.4)
    }
    
}