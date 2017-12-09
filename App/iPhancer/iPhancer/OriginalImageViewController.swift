//
//  OriginalImageViewController.swift
//  iPhancer
//
//  Created by Parker Thomas on 12/8/17.
//  Copyright © 2017 Parker Thomas. All rights reserved.
//

import Foundation
import UIKit
import PINRemoteImage

class OriginalImageViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //imageView.image = UIImage(named: "loading")
        setNavBarTitle(title: "Loading")
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        UIImageWriteToSavedPhotosAlbum(imageView.image!, nil, nil, nil)
    }
    
    func setImage(filename: String) {
        let imgURL = "https://localhost:5000/enhanced" + filename
        imageView.pin_setImage(from: URL(string: imgURL)!)
    }
    
    func setNavBarTitle(title: String) {
        navigationBar.title = title
    }
}
