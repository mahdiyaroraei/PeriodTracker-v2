//
//  LicenseHelper.swift
//  Minoo
//
//  Created by Mahdiar  on 11/28/17.
//  Copyright © 2017 Mostafa Oraei. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

class LicenseHelper {
    
    private final let appName = "period_tracker"
    
    private static var instance: LicenseHelper?
    
    public static func getInstance(delegate: LicenseDelegate?) -> LicenseHelper {
        if LicenseHelper.instance == nil {
            
            if let delegate = delegate {
                LicenseHelper.instance = LicenseHelper(delegate: delegate)
            }
        }
        
        return LicenseHelper.instance!
    }
    
    
    public func activation(email: String , code: String? , completion: @escaping ((Bool) -> Void)) {
        
        guard let code = code else { return }
        
        let parameter: Dictionary<String , Any> = [
            "email" : email,
            "app" : appName,
            "code" : code
        ]
        
        HttpLicense().request(endpoint: "activation", method: .POST, parameters: parameter
            , completionHandler: { (data, response, error) in
                if let data = data {
                    do {
                        let activation = try JSONDecoder().decode(Activation.self, from: data)
                        if let msg = activation.msg {
                            completion(false)
                        } else {
                            if let email = activation.user?.email , let licenseId = activation.id , let userId = activation.user_id {
                                License.addLicense(licenseId: licenseId, userId: Int(userId)!, email: email)
                                DispatchQueue.main.async {
                                    self.delegate?.openApplication()
                                }
                                completion(true)
                            } else {
                                completion(false)
                            }
                        }
                        
                    } catch {
                        let asd = ""
                    }
                } else {
                    
                }
        })
        
    }
    
    // TODO
    public func buy(email: String , code: String? , completion: @escaping ((Bool) -> Void)) {
        
        var discount = code
        
        if discount == nil {
            discount = ""
        }
        
        guard let discountString = discount else {
            return
        }
        
        let parameters = [
            "email": email,
            "discount": discountString, //TODO
            "app": appName
        ]
        
        HttpLicense().request(endpoint: "buy", method: .POST, parameters: parameters) { (data, response, error) in
            do{
                if let data = data {
                    let jsonSerialized = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
                    
                    if let json = jsonSerialized {
                        if let link = json["url"] as? String {
                            DispatchQueue.main.async {
                                
                                guard let url = URL(string: link) else {
                                    completion(false)
                                    return
                                }
                                
                                completion(true)
                                
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                
                            }
                        }
                    }
                }
            } catch let error as NSError {
                completion(false)
                print(error.localizedDescription)
            }
        }
    }
    
    
    
    private init(delegate: LicenseDelegate) {
        self.delegate = delegate
        checkEnabalityLicense { (response) in
            if response {
                if self.checkLicenseExist() {
                    if self.checkInternetConnection() {
                        self.checkLicenseStatus() { (response) in
                            if response {
                                UserDefaults.standard.set("yes", forKey: "License")
                                self.openApplication()
                            } else {
                                UserDefaults.standard.set("no", forKey: "License")
                                self.showUserLicenseAvailableOnAnotherDevice()
                                self.showLicenseViewController()
                            }
                        }
                    } else {
                        //                        self.openApplication()
                    }
                } else {
                    if self.checkInternetConnection() {
                        self.showLicenseViewController()
                    } else {
                        self.openFirstOpenNeedInternetConnection()
                    }
                }
            } else {
                //                self.showCoverViewController()
            }
        }
    }
    
    
    private var delegate: LicenseDelegate?
    
    private func openFirstOpenNeedInternetConnection() {
        DispatchQueue.main.async {
//            self.delegate?.present(viewController: NoInternetViewController())
        }
    }
    
    private func openApplication() {
        self.delegate?.openApplication()
    }
    
    //    private func showCoverViewController() {
    //        DispatchQueue.main.async {
    //
    //            let navigationController = UINavigationController()
    //            navigationController.viewControllers = [ListNoteViewController()]
    //
    //            self.delegate?.present(viewController: navigationController)
    //        }
    //    }
    
    private func showLicenseViewController() {
        DispatchQueue.main.async {
            self.delegate?.present(viewController: LicenseViewController())
        }
    }
    
    private func showUserLicenseAvailableOnAnotherDevice() {
        UserDefaults.standard.set(true, forKey: "another-device-use-this-code")
        License.deleteLicense()
    }
    
    private func checkInternetConnection() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
    }
    
    private func checkLicenseStatus(_ responseCompletion: @escaping (Bool) -> Void) {
        
        let parameters: Dictionary<String , Any> = [
            "app": appName,
            "license_id": License.licenseId!,
            "user_id": License.userId!
        ]
        
        // TODO
        HttpLicense().request(endpoint: "login", method: .POST, parameters: parameters, completionHandler: { (data, response, error) in
            do{
                if let data = data {
                    let jsonSerialized = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
                    if let json = jsonSerialized {
                        if let status = json["status"] as? String {
                            let isLicenseValid = status == "1"
                            
                            responseCompletion(isLicenseValid)
                        }
                    }
                }
            }catch let error as NSError {
                print(error.localizedDescription)
            }
        })
    }
    
    private func checkLicenseExist() -> Bool {
        
        return License.isValid()
    }
    
    private func checkEnabalityLicense(_ responseCompletion: @escaping (Bool) -> Void) {
        HttpLicense().request(endpoint: "config/status/\(appName)", method: .GET, parameters: nil, completionHandler: { (data, response, error) in
            do{
                if let data = data {
                    let jsonSerialized = try JSONSerialization.jsonObject(with: data, options: []) as? [String:String]
                    if let json = jsonSerialized {
                        if let status = json["status"] {
                            if status == "1" {
                                responseCompletion(true)
                            } else {
                                responseCompletion(false)
                            }
                        }
                    }
                }
            }catch let error as NSError {
                responseCompletion(true)
                print(error.localizedDescription)
            }
        })
    }
}

class License {
    
    public static func isValid() -> Bool {
        guard let license = License.licenseId , license > 1 else { return false }
        
        guard let user = License.userId , user > 0 else { return false }
        
        guard let email = License.email , email != "" else { return false }
        
        return true
    }
    
    public static var licenseId: Int? {
        get {
            let id = UserDefaults.standard.integer(forKey: "license_id")
            if id > 0 {
                return UserDefaults.standard.integer(forKey: "license_id")
            } else {
                return 1
            }
        }
    }
    
    public static var userId: Int? {
        get {
            let id = UserDefaults.standard.integer(forKey: "user_id")
            if id > 0 {
                return UserDefaults.standard.integer(forKey: "user_id")
            } else {
                return 1
            }
        }
    }
    
    public static var email: String? {
        get {
            let e = UserDefaults.standard.string(forKey: "email")
            if let e = e {
                return e
            } else {
                return ""
            }
        }
    }
    
    public static func deleteLicense() {
        UserDefaults.standard.set(0, forKey: "license_id")
        UserDefaults.standard.set(0, forKey: "user_id")
        UserDefaults.standard.set(nil, forKey: "email")
    }
    
    public static func addLicense(licenseId: Int , userId: Int , email: String) {
        UserDefaults.standard.set(licenseId, forKey: "license_id")
        UserDefaults.standard.set(userId, forKey: "user_id")
        UserDefaults.standard.set(email, forKey: "email")
        
        //        NotificationsCenter.updatePlayerId()
    }
}

protocol LicenseDelegate {
    func present(viewController: UIViewController)
    func openApplication()
}
