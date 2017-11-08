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
    
//    let captureSession = AVCaptureSession()
//    let stillImageOutut = AVCapturePhotoOutput()
//    var previewLayer: AVCaptureVideoPreviewLayer?
//    
//    var captureDevice: AVCaptureDevice?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        captureSession.sessionPreset = AVCaptureSession.Preset.high
//
//        if let availableDevices = AVCaptureDevice.devices() as? [AVCaptureDevice] {
//            for device in availableDevices {
//                if device.hasMediaType(AVMediaType.video) {
//
//                }
//            }
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pickPhoto(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        
        //imagePicker.sourceType = .photoLibrary
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        
        imagePicker.delegate = self
        // show the image picker
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func goButtonPushed(_ sender: UIButton) {
        //process image
    }
    
}

