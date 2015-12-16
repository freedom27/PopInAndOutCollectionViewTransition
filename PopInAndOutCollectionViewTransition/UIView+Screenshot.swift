//
//  UIView+Screenshot.swift
//  PopInAndOutCollectionViewTransition
//
//  Created by Stefano Vettor on 15/12/15.
//  Copyright © 2015 Stefano Vettor. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    var screenshot: UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
        if let tableView = self as? UITableView {
            tableView.superview!.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        } else {
            layer.renderInContext(UIGraphicsGetCurrentContext()!)
        }
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image
    }
}