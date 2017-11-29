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
    
}
