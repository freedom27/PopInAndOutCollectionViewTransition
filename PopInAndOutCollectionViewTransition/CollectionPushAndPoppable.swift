//
//  CollectionPushAndPoppable.swift
//  PopInAndOutCollectionViewTransition
//
//  Created by Stefano Vettor on 15/12/15.
//  Copyright © 2015 Stefano Vettor. All rights reserved.
//

import Foundation
import UIKit

protocol CollectionPushAndPoppable {
    var sourceCell: UICollectionViewCell? { get }
    var collectionView: UICollectionView? { get }
    var view: UIView! { get }
}