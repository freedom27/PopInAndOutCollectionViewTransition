//
//  ViewController.swift
//  DemoApp
//
//  Created by Stefano Vettor on 15/12/15.
//  Copyright © 2015 Stefano Vettor. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController {
    
    var pictures: [String]?
    var sourceCell: UICollectionViewCell?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let path = NSBundle.mainBundle().pathForResource("Pictures", ofType: "plist") {
            pictures = NSArray(contentsOfFile: path) as? [String]
        }
        
        self.navigationController?.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures!.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cellIdentifier = "photoCell"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! PictureCell
        
        let picName = pictures![indexPath.row] + ".jpg"
        cell.picture.image = UIImage(named: picName)
        
        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! ViewController
        let cell = sender as! PictureCell
        sourceCell = cell
        vc.picture = cell.picture.image
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let screenRect = UIScreen.mainScreen().bounds
        let screenWidth = screenRect.size.width
        let cellW = (screenWidth - 2)/3
        let cellH = cellW
        
        return CGSize(width: cellW, height: cellH)
    }
}

//MARK: UINavigationControllerDelegate
extension CollectionViewController: UINavigationControllerDelegate {
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return animatorForOperation(operation)
    }
}

//MARK: CollectionPushAndPoppable
extension CollectionViewController: CollectionPushAndPoppable {}