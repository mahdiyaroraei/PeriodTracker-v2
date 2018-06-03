//
//  HttpLicense.swift
//  Minoo
//
//  Created by Mahdiar  on 11/28/17.
//  Copyright © 2017 Mostafa Oraei. All rights reserved.
//

import Foundation
class HttpLicense {
    public static let BASE_URL = "http://applauncher.ir/license/public/"
    
    func request(endpoint: String , method: HttpMethod, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        self.request(endpoint: endpoint, method: method, parameters: nil, completionHandler: completionHandler)
    }
    
    func request(endpoint: String, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        self.request(endpoint: endpoint, method: nil, parameters: nil, completionHandler: completionHandler)
    }
    
    func request(endpoint: String , method: HttpMethod? , parameters: Dictionary<String , Any>? , completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let request = NSMutableURLRequest(url: URL(string: "\(HttpLicense.BASE_URL)\(endpoint)")!)
        let session = URLSession.shared
        
        if let method = method , method == .POST {
            request.httpMethod = "POST"
            
            if let params = parameters {
                request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
            }
            
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: completionHandler)
        
        task.resume()
    }
}
