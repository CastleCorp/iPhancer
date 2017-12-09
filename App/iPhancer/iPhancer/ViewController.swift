//
//  ViewController.swift
//  iPhancer
//
//  Created by Parker Thomas on 11/6/17.
//  Copyright © 2017 Parker Thomas. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var resolutionPicker: UISegmentedControl!
    
    var resolution: String = "orig"
    var imageName: String = "name"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
        
        imageName = String(image.hash)
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func takePhoto(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
   
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        switch resolutionPicker.selectedSegmentIndex {
        case 0:
            resolution = "orig";
        case 1:
            resolution = "medium";
        case 2:
            resolution = "small";
        default:
            resolution = "orig";
        }
    }
    
    func noImageAlert() {
        let alert = UIAlertController(title: "No image selected", message: "Please select an image to process", preferredStyle: UIAlertControllerStyle.alert)
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
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "showResultsPage" {
            if imageView.image == nil {
                noImageAlert()
                return false
            }
            return true
        }
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showResultsPage" {
            
            // Upload image to server
            let params = [String:String]()
            RestAPIManager.singleton.uploadImage(imageView: imageView, param: params, filename: imageName+".jpg")
            
            // Begin processing the image on the server
            RestAPIManager.singleton.processImage(resolution: resolution, use_gpu: "true", filename: imageName+".jpg")
            
            let rvc = segue.destination as! ResultsPageViewController
            //let oivc = OriginalImageViewController()
            //let pivc = ProcessedImageViewController()
            
            //rvc.originalImageViewController = oivc
            //rvc.processedImageViewController = pivc
            rvc.originalImage = imageView.image
           // rvc.downloadedImage = UIImage()
            rvc.filename = imageName
        }
    }
    
}

