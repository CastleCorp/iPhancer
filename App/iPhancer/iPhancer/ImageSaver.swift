//
//  ImageSaver.swift
//  iPhancer
//
//  Created by Parker Thomas on 12/8/17.
//  Copyright © 2017 Parker Thomas. All rights reserved.
//

import Foundation
import UIKit

class ImageSaver {
    
    private var processed: UIImage
    
    init() {
        processed = UIImage()
    }
 
    func getProcessed() -> UIImage {
        return processed
    }
    
    func setProcessed(image: UIImage) {
        processed = image
    }
}
