//
//  Extensions.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 8/1/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit
import Alamofire

extension UIView {
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        
        let border = CAShapeLayer()
        border.path = path.cgPath
        border.fillColor = UIColor.clear.cgColor
        border.lineWidth = 3
        border.strokeColor = UIColor.lightGray.cgColor
        self.layer.addSublayer(border)
    }
    
    
    func dropShadow(scale: Bool = true) {
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 15
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func dropShine(scale: Bool = true) {
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 25
        
        self.layer.shadowPath = UIBezierPath(rect: CGRect(x: 10, y: 10, width: 50, height: 50)).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

extension Alamofire.SessionManager{
    @discardableResult
    open func requestWithoutCache(
        _ url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters?,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil)
        -> DataRequest
    {
        do {
            var urlRequest = try URLRequest(url: url, method: method, headers: headers)
            urlRequest.cachePolicy = .reloadIgnoringCacheData // <<== Cache disabled
            let encodedURLRequest = try encoding.encode(urlRequest, with: parameters)
            return request(encodedURLRequest)
        } catch {
            print(error)
            return request(URLRequest(url: URL(string: "http://example.com/wrong_request")!))
        }
    }
}

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFill, complition: ((Bool) -> Void)? = nil) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else {
                    if complition != nil {
                        complition!(false)
                    }
                    return
            }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
                if complition != nil {
                    complition!(true)
                }
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFill, complition: ((Bool) -> Void)? = nil) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode, complition: complition)
    }
}

extension UIColor{
    static func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
}

extension UIViewController {
    func showModal(modalObject: Modal) {
        let vc = ModalViewController()
        vc.modalObject = modalObject
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false, completion: nil)
    }
}

extension String {
    public static var loremipsum: String {
        get {
            return "لورم ایپسوم متن ساختگی با تولید سادگی نامفهوم از صنعت چاپ و با استفاده از طراحان گرافیک است. چاپگرها"
        }
    }
    
    public static var bigLoremipsum: String {
        return "لورم ایپسوم متن ساختگی با تولید سادگی نامفهوم از صنعت چاپ و با استفاده از طراحان گرافیک است. چاپگرها و متون بلکه روزنامه و مجله در ستون و سطرآنچنان که لازم است و برای شرایط فعلی تکنولوژی مورد نیاز و کاربردهای متنوع با هدف بهبود ابزارهای کاربردی می باشد. کتابهای زیادی در شصت و سه درصد گذشته، حال و آینده شناخت فراوان جامعه و متخصصان را می طلبد تا با نرم افزارها شناخت بیشتری را برای طراحان رایانه ای علی الخصوص طراحان خلاقی و فرهنگ پیشرو در زبان فارسی ایجاد کرد. در این صورت می توان امید داشت که تمام و دشواری موجود در ارائه راهکارها و شرایط سخت تایپ به پایان رسد وزمان مورد نیاز شامل حروفچینی دستاوردهای اصلی و جوابگوی سوالات پیوسته اهل دنیای موجود طراحی اساسا مورد استفاده قرار گیرد.لورم ایپسوم متن ساختگی با تولید سادگی نامفهوم از صنعت چاپ و با استفاده از طراحان گرافیک است. چاپگرها و متون بلکه روزنامه و مجله در ستون و سطرآنچنان که لازم است و برای شرایط فعلی تکنولوژی مورد نیاز و کاربردهای متنوع با هدف بهبود ابزارهای کاربردی می باشد. کتابهای زیادی در شصت و سه درصد گذشته، حال و آینده شناخت فراوان جامعه و متخصصان را می طلبد تا با نرم افزارها شناخت بیشتری را برای طراحان رایانه ای علی الخصوص طراحان خلاقی و فرهنگ پیشرو در زبان فارسی ایجاد کرد. در این صورت می توان امید داشت که تمام و دشواری موجود در ارائه راهکارها و شرایط سخت تایپ به پایان رسد وزمان مورد نیاز شامل حروفچینی دستاوردهای اصلی و جوابگوی سوالات پیوسته اهل دنیای موجود طراحی اساسا مورد استفاده قرار گیرد."
    }
}

extension Int {
    var forrmated: String {
        if self < 1000 {
            return String("\(self)")
        } else if self < 1000000 {
            return String("\(self / 1000) هزار")
        } else {
            return String("\(self / 1000000) میلیون")
        }
    }
}
public extension UIImage {
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}

extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}

extension String {
    
    
    func isValidEmail() -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    var floatValue: Float {
        return (self as NSString).floatValue
    }
}

enum Font {
    case IRANSans
    case IRANSansBold
    case IRANYekan
    case IRANYekanBold
    case IRANSansUltraLight
}


extension UITextView {
    
    func font(_ font: Font , size: CGFloat = 15) {
        switch font {
        case .IRANSans:
            self.font = UIFont(name: "IRANSans(FaNum)", size: size)!
            
        case .IRANSansBold:
            self.font = UIFont(name: "IRANSansFaNum-Bold", size: size)!
            
        case .IRANSansUltraLight:
            self.font = UIFont(name: "IRANSansFaNum-UltraLight", size: size)!
            
        case .IRANYekan:
            self.font = UIFont(name: "IRANYekanMobile", size: size)!
            
        case .IRANYekanBold:
            self.font = UIFont(name: "IRANYekanMobile-Bold", size: size)!
            
        default:
            self.font = UIFont(name: "IRANSans(FaNum)", size: size)!
        }
    }
}

extension UITextField {
    
    func font(_ font: Font , size: CGFloat = 15) {
        switch font {
        case .IRANSans:
            self.font = UIFont(name: "IRANSans(FaNum)", size: size)!
            
        case .IRANSansBold:
            self.font = UIFont(name: "IRANSansFaNum-Bold", size: size)!
            
        case .IRANSansUltraLight:
            self.font = UIFont(name: "IRANSansFaNum-UltraLight", size: size)!
            
        case .IRANYekan:
            self.font = UIFont(name: "IRANYekanMobile", size: size)!
            
        case .IRANYekanBold:
            self.font = UIFont(name: "IRANYekanMobile-Bold", size: size)!
            
        default:
            self.font = UIFont(name: "IRANSans(FaNum)", size: size)!
        }
    }
}

extension UILabel {
    
    func font(_ font: Font , size: CGFloat = 15) {
        switch font {
        case .IRANSans:
            self.font = UIFont(name: "IRANSans(FaNum)", size: size)!
            
        case .IRANSansBold:
            self.font = UIFont(name: "IRANSansFaNum-Bold", size: size)!
            
        case .IRANSansUltraLight:
            self.font = UIFont(name: "IRANSansFaNum-UltraLight", size: size)!
            
        case .IRANYekan:
            self.font = UIFont(name: "IRANYekanMobile", size: size)!
            
        case .IRANYekanBold:
            self.font = UIFont(name: "IRANYekanMobile-Bold", size: size)!
            
        default:
            self.font = UIFont(name: "IRANSans(FaNum)", size: size)!
        }
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        self.navigationController?.navigationBar.isHidden = false
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
extension Dictionary {
    func sortedKeys(isOrderedBefore:(Key,Key) -> Bool) -> [Key] {
        return Array(self.keys).sorted(by: isOrderedBefore)
    }
    
    // Slower because of a lot of lookups, but probably takes less memory (this is equivalent to Pascals answer in an generic extension)
    func sortedKeysByValue(isOrderedBefore:(Value, Value) -> Bool) -> [Key] {
        return sortedKeys {
            isOrderedBefore(self[$0]!, self[$1]!)
        }
    }
    
    // Faster because of no lookups, may take more memory because of duplicating contents
    func keysSortedByValue(isOrderedBefore:(Value, Value) -> Bool) -> [Key] {
        return Array(self)
            .sorted() {
                let (_, lv) = $0
                let (_, rv) = $1
                return isOrderedBefore(lv, rv)
            }
            .map {
                let (k, _) = $0
                return k
        }
    }
}

extension UITableView {
    func scrollToBottom(animated: Bool) {
        let y = contentSize.height - frame.size.height
        setContentOffset(CGPoint(x: 0, y: (y<0) ? 0 : y), animated: animated)
    }
}
