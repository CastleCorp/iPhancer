//
//  RestAPIManager.swift
//  iPhancer
//
//  Created by Parker Thomas on 12/4/17.
//  Copyright © 2017 Parker Thomas. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class RestAPIManager {
    //let baseURL = "10.47.41.2:5000/iPhancer"
    let baseURL = "http://localhost:5000/"
    static let singleton = RestAPIManager()
    public var saver = ImageSaver()
    
    public var getRequestResponseString: NSString = ""
    public var downloadedImage: UIImageView!
    
    public var resultsPageVC: ResultsPageViewController!
    
    
    // /upload
    func uploadImage(imageView: UIImageView, param: [String : String]?, filename: String) {
        let request = NSMutableURLRequest(url: URL(string: baseURL+"upload")!)
        request.httpMethod = "POST"
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let imageData = UIImageJPEGRepresentation(imageView.image!, 1)
        
        if(imageData==nil) { return; }
        
        request.httpBody = createBodyWithParameters(parameters: param, filePathKey: "image", imageDataKey: imageData! as NSData, boundary: boundary, filename: filename) as Data
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) -> Void in
            if let data = data {
                //print("response: \(String(describing: response))")
                
                let responseString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                print("response data: \(responseString!)")
                
                
            } else if let error = error {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String, filename: String) -> NSData {
        let body = NSMutableData()
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        
        let mimetype = "image/jpg"
        
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey as Data)
        body.appendString(string: "\r\n")
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    
    // generic GET Request
    func getRequest(url: URL) -> String {
        let task = URLSession.shared.dataTask(with: url, completionHandler: {
            (data, response, error) -> Void in
            if let data = data {
                // print("response: \(String(describing: response))")
                
                let responseString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                print("response data: \(responseString!)")
                
                self.getRequestResponseString = responseString!
                
            } else if let error = error {
                print(error.localizedDescription)
            }
        })
        task.resume()
        return self.getRequestResponseString as String
    }
    
    // /process
    func processImage(resolution: String, use_gpu: String, filename: String) -> String {
        let url = URL(string: baseURL+"process?resolution="+resolution+"&use_gpu="+use_gpu+"&filename="+filename)
         return getRequest(url: url!)
    }
    
    // /getProcessStatus
    func getProcessStatus(filename: String) -> String {
        let url = URL(string: baseURL+"getProcessStatus?filename="+filename)
         return getRequest(url: url!)
    }

    
    func getDataFromURL(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
        }.resume()
    }
    
    func downloadImage(url: URL, filename: String) {
        print("Starting download")
        getDataFromURL(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                let image: UIImage = UIImage(data: data)!
                var processedVC = self.getViewController(withIdentifier: "ProcessedViewController") as! ProcessedImageViewController
                processedVC.setImage(image: image)
            }
        }
    }

    fileprivate func getViewController(withIdentifier identifier: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
    
    func getProcessedPhoto(filename: String) {
        let url = URL(string: baseURL+"enhanced/"+filename)
        downloadImage(url: url!, filename: filename)
        
    }
    
    func getDownloadedImage() -> UIImageView {
        return downloadedImage
    }
    
}

extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
