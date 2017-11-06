//
//  ViewController.swift
//  iPhancer
//
//  Created by Parker Thomas on 11/6/17.
//  Copyright © 2017 Parker Thomas. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var resolutionPicker: UIPickerView!
    @IBOutlet weak var imageView: UIImageView!
    
    var pickerData: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // connect picker data
        self.resolutionPicker.delegate = self
        self.resolutionPicker.dataSource = self
        
        // initialize picker data
        pickerData = ["original", "high", "medium", "small", "tiny"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    
    @IBAction func pickPhoto(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        
        imagePicker.sourceType = .photoLibrary
        
//        if UIImagePickerController.isSourceTypeAvailable(.camera) {
//            imagePicker.sourceType = .camera
//        } else {
//            imagePicker.sourceType = .photoLibrary
//        }
        
        imagePicker.delegate = self
        // show the image picker
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
        
        dismiss(animated: true, completion: nil)
    }
}

