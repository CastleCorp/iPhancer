//
//  ProcessedImageViewController.swift
//  iPhancer
//
//  Created by Parker Thomas on 12/8/17.
//  Copyright © 2017 Parker Thomas. All rights reserved.
//

import Foundation
import UIKit

class ProcessedImageViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setImage(image: UIImage(named:"loading")!)
        setNavBarTitle(title: "Loading")
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        UIImageWriteToSavedPhotosAlbum(imageView.image!, nil, nil, nil)
    }
    
    func setImage(image: UIImage) {
        imageView.image = image
    }
    
    func setNavBarTitle(title: String) {
        navigationBar.title = title
    }
    
    func makeWebView(url: String) {
        let url = URL(string: url)
        let data = try! Data(contentsOf: url!)
        let myWebView:UIWebView = UIWebView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        myWebView.contentMode = .scaleAspectFit
        myWebView.scalesPageToFit = true
        myWebView.frame = self.view.bounds
        myWebView.load(data, mimeType: "image/png", textEncodingName: "UTF-8", baseURL: NSURL() as URL)
        
        self.imageView.addSubview(myWebView)
    }
    
}
