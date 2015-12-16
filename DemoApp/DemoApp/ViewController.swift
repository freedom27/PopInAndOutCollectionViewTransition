//
//  ViewController.swift
//  DemoApp
//
//  Created by Stefano Vettor on 15/12/15.
//  Copyright © 2015 Stefano Vettor. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var picture: UIImage?
    
    @IBOutlet weak var pictureView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pictureView.image = picture
    }
    
}