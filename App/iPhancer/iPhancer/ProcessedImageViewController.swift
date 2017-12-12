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
        setImage(image: UIImage(named:"loading")!)
        setNavBarTitle(title: "Processed")
        navigationBar.leftBarButtonItem?.isEnabled = false
    }
    
    func imageSaveAlert() {
        let alert = UIAlertController(title: "Image saved", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: {action in
            switch action.style {
            case .default:
                alert.dismiss(animated: true, completion: nil)
                
            case .cancel:
                alert.dismiss(animated: true, completion: nil)
                
            case .destructive:
                print("destructive")
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        UIImageWriteToSavedPhotosAlbum(imageView.image!, nil, nil, nil)
        imageSaveAlert()
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
        imageView.image = UIImage(data: data)
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        navigationBar.leftBarButtonItem!.isEnabled = true
        
    }
    
}
