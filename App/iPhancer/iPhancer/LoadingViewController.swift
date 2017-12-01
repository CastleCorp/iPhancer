//
//  LoadingViewController.swift
//  iPhancer
//
//  Created by Parker Thomas on 11/29/17.
//  Copyright © 2017 Parker Thomas. All rights reserved.
//

import Foundation
import UIKit

class LoadingViewController: UIViewController {
    
    var resolution: String!
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("resolution \(resolution)")
        print("image \(image)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // TODO: Poll server for status of process until response is "Done"
    // TODO: When processing is finished, GET the processed image and display original and processed images in Results page
    
}
