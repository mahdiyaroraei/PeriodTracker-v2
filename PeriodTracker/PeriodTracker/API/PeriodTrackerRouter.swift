//
//  PeriodTrackerRouter.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 6/22/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import Alamofire

public enum PeriodTrackerRouter: URLRequestConvertible {
    static let baseURLString = "http://192.168.1.38/license/public/"
    
    case get(Int)
    case create([String: Any])
    case delete(Int)
    case checkLicenseStatus([String: Any])
    
    public func asURLRequest() throws -> URLRequest {
        var method: HTTPMethod {
            switch self {
            case .get:
                return .get
            case .create:
                return .post
            case .delete:
                return .delete
            case .checkLicenseStatus:
                return .post
            }
        }
        let params: ([String: Any]?) = {
            switch self {
            case .get, .delete:
                return nil
            case .create(let newTodo):
                return (newTodo)
            case .checkLicenseStatus(let userDetail):
                return (userDetail);
            }
        }()
        let url: URL = {
            // build up and return the URL for each endpoint
            let relativePath: String?
            switch self {
            case .get(let number):
                relativePath = "todos/\(number)"
            case .create:
                relativePath = "todos"
            case .delete(let number):
                relativePath = "todos/\(number)"
            case .checkLicenseStatus:
                relativePath = "checklicense"
            }
            var url = URL(string: PeriodTrackerRouter.baseURLString)!
            if let relativePath = relativePath {
                url = url.appendingPathComponent(relativePath)
            }
            return url
        }()
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        let encoding = JSONEncoding.default
        return try encoding.encode(urlRequest, with: params)
    }
}
