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
        
        if let path = Bundle.main.path(forResource: "Pictures", ofType: "plist") {
            pictures = NSArray(contentsOfFile: path) as? [String]
        }
        
        // It is important to define a navigationController delegate! In this case
        // I used the ViewController as delegate... but it is not mandatory
        self.navigationController?.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellIdentifier = "photoCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! PictureCell
        
        let picName = pictures![(indexPath as NSIndexPath).row] + ".jpg"
        cell.picture.image = UIImage(named: picName)
        
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ViewController
        let cell = sender as! PictureCell
        // This next line is very importat for the proper functioning of the animation:
        // the sourceCell property tells the animator which is the cell involved in the transition
        sourceCell = cell
        vc.picture = cell.picture.image
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenRect = UIScreen.main.bounds
        let screenWidth = screenRect.size.width
        let cellW = (screenWidth - 2)/3
        let cellH = cellW
        
        return CGSize(width: cellW, height: cellH)
    }
}

//MARK: UINavigationControllerDelegate
extension CollectionViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        // In this method belonging to the protocol UINavigationControllerDelegate you must
        // return an animator conforming to the protocol UIViewControllerAnimatedTransitioning.
        // To perform the Pop in and Out animation PopInAndOutAnimator should be returned
        return PopInAndOutAnimator(operation: operation)
    }
}

//MARK: CollectionPushAndPoppable
extension CollectionViewController: CollectionPushAndPoppable {}
