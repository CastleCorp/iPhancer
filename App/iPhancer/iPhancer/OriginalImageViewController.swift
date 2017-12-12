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
        setNavBarTitle(title: "Original")
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
    
    func setImage(filename: String) {
        let imgURL = "https://localhost:5000/enhanced" + filename
        imageView.pin_setImage(from: URL(string: imgURL)!)
    }
    
    func setNavBarTitle(title: String) {
        navigationBar.title = title
    }
}
