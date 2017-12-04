//
//  RestAPIManager.swift
//  iPhancer
//
//  Created by Parker Thomas on 12/4/17.
//  Copyright © 2017 Parker Thomas. All rights reserved.
//

import Foundation

class RestAPIManager {
    
    let baseURL = "10.47.41.2:5000/iPhancer"
    let singleton = RestAPIManager()
    
    // GET request
    func makeHTTPGetRequest(theURL: String, resultsHandler: @escaping ((JSON) -> Void)) {
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let url = URL(string: theURL)!
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                print(error!.localizedDescription)
            } else {
                if let jsonData = data {
                    let json = try! JSON(data: jsonData)
                    
                    resultsHandler(json)
                }
            }
        })
        task.resume()
    }
    
}
