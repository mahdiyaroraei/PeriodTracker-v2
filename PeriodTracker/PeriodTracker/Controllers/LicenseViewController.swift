//
//  LicenseViewController.swift
//  Minoo
//
//  Created by Mahdiar  on 11/28/17.
//  Copyright © 2017 Mostafa Oraei. All rights reserved.
//

import UIKit

class LicenseViewController: UIViewController {
    var window: UIWindow?
    
    let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let supportView: UIView = {
        let v = UIView()
        return v
    }()
    
    let supportImage: UIImageView = {
        let i = UIImageView()
        i.contentMode = .scaleAspectFill
        i.image = UIImage(named: "SupportViewController")
        return i
    }()
    
    let supportButtomYes: UIButton = {
        let b = UIButton()
        //        b.translatesAutoresizingMaskIntoConstraints = false
        b.backgroundColor = .clear
        return b
    }()
    
    let supportButtomNo: UIButton = {
        let b = UIButton()
        //    b.translatesAutoresizingMaskIntoConstraints = false
        b.backgroundColor = .clear
        
        return b
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "صفحه خرید برنامه"
        label.font(.IRANSansBold, size: 27)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var flowerImageView: UIImageView {
        get {
            let imageView = UIImageView()
            //imageView.image = UIImage(named: "flower_opacity")
            
            imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }
    }
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "logo")
        imageView.contentMode = .scaleAspectFit
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var lineView: UIView {
        get {
            let view = UIView()
            view.backgroundColor = .white
            
            view.heightAnchor.constraint(equalToConstant: 2).isActive = true
            
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }
    }
    
    let fieldsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 24
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var iconImageView: UIImageView {
        get {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "ic_email")
            imageView.contentMode = .scaleAspectFit
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }
    }
    
    var inputTextField: TextField {
        get {
            let textField = TextField()
            textField.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            
            let paragraph = NSMutableParagraphStyle()
            paragraph.baseWritingDirection = .rightToLeft
            paragraph.alignment = .center
            
            textField.attributedPlaceholder = NSAttributedString(string: "ایمیل شما",
                                                                 attributes: [NSForegroundColorAttributeName: UIColor.white , NSParagraphStyleAttributeName: paragraph])
            textField.font = UIFont(name: "IRANSans(FaNum)", size: 15)
            textField.textColor = .white
            
            textField.layer.borderColor = UIColor.white.withAlphaComponent(0.6).cgColor
            textField.layer.borderWidth = 1
            textField.layer.cornerRadius = 25
            
            textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
            
            textField.translatesAutoresizingMaskIntoConstraints = false
            return textField
        }
    }
    
    let buyButton: UIButton = {
        let button = UIButton()
        button.setTitle("خرید برنامه", for: .normal)
        button.backgroundColor = UIColor.white.withAlphaComponent(0.85)
        button.titleLabel?.font(.IRANSansBold , size: 21)
        button.setTitleColor(UIColor.uicolorFromHex(rgbValue: 0x1cbeb3), for: .normal)
        button.layer.cornerRadius = 25
        
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let noButton: UIButton = {
        let button = UIButton()
        button.setTitle("فعلا نه", for: .normal)
        button.backgroundColor = .clear
        button.titleLabel?.font(.IRANSansBold , size: 21)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 25
        
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 3
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let movieStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 3
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let supportLabel: UILabel = {
        let label = UILabel()
        label.font(.IRANSans , size: 17)
        label.textColor = UIColor.white.withAlphaComponent(0.9)
        label.text = "در صورت بروز مشکل"
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let supportButton: UIButton = {
        let button = UIButton()
        button.setTitle("تماس با پشتیبانی", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.3), for: .highlighted)
        
        button.titleLabel?.font(.IRANSansBold , size: 19)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let movieLabel: UILabel = {
        let label = UILabel()
        label.font(.IRANYekan , size: 12)
        label.textColor = UIColor.white.withAlphaComponent(0.9)
        label.text = "مشاهده فیلم معرفی اپ"
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let movieButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "movie")
        imageView.contentMode = .scaleAspectFit
        imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let loadingActivityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.hidesWhenStopped = true
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    var emailTextField: TextField?
    var codeTextField: TextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        let tabGradiant = CAGradientLayer()
        let tabDefaultNavigationBarFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        
        tabGradiant.frame = tabDefaultNavigationBarFrame
        
        tabGradiant.colors = [UIColor.uicolorFromHex(rgbValue: 0x06bf9b).cgColor, UIColor.uicolorFromHex(rgbValue: 0x07a1bb).cgColor]
        
        let x: Double! = 45 / 360.0
        let a = pow(sinf(Float(2.0 * .pi * ((x + 0.75) / 2.0))),2.0);
        let b = pow(sinf(Float(2 * .pi * ((x+0.0)/2))),2);
        let c = pow(sinf(Float(2 * .pi * ((x+0.25)/2))),2);
        let d = pow(sinf(Float(2 * .pi * ((x+0.5)/2))),2);
        
        tabGradiant.endPoint = CGPoint(x: CGFloat(c),y: CGFloat(d))
        tabGradiant.startPoint = CGPoint(x: CGFloat(a),y:CGFloat(b))
        
        self.backgroundImage.image = self.image(fromLayer: tabGradiant)
        //self.backgroundImage.image = UIImage(named: "buyPage")
        
        setupView()
        setupSupportView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //    let closeButton: UIButton = {
    //        let b = UIButton()
    //        b.setImage(UIImage(named: "exit")?.withRenderingMode(.alwaysTemplate), for: .normal)
    //        b.tintColor = .white
    //
    //        return b
    //    }()
    
    func setupSupportView() {
        //        let width = view.frame.width
        //        let height = view.frame.height
        //
        //        view.addSubview(supportView)
        ////        supportView.addSubview(supportImage)
        //        supportView.addSubview(supportButtomYes)
        //        supportView.addSubview(supportButtomNo)
        //
        //        supportView.frame = view.frame
        //        supportImage.frame = supportView.frame
        //        supportButtomNo.frame = CGRect(x: 0, y: height-60, width: width/2, height: 60)
        //        supportButtomYes.frame = CGRect(x: width/2, y: height-60, width: width/2, height: 60)
        
        //        supportButtomYes.addTarget(self, action: #selector(YesTapped), for: .touchUpInside)
        //        supportButtomNo.addTarget(self, action: #selector(NoTapped), for: .touchUpInside)
        
    }
    
    //    @objc func YesTapped() {
    //        let width = view.frame.width
    //        let height = view.frame.height
    //
    //        UIView.animate(withDuration: 0.4, delay: 0.2, options: .curveEaseIn, animations: {
    //            self.supportView.frame = CGRect(x: 0, y: height, width: width, height: height)
    //        }, completion: nil)
    //    }
    //
    @objc func NoTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        self.view.frame.origin.y = -150
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    func setupView() {
        self.view.addSubview(self.backgroundImage)
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.logoImageView)
        
        let leadingLineView = self.lineView
        let trailingLineView = self.lineView
        
        self.view.addSubview(leadingLineView)
        self.view.addSubview(trailingLineView)
        
        self.view.addSubview(fieldsStackView)
        
        for _ in 0...15 {
            let imageView = self.flowerImageView
            
            self.view.addSubview(imageView)
            
            let leadingOffset: CGFloat = CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * CGFloat(UIScreen.main.bounds.width)
            let topOffset: CGFloat = CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * CGFloat(UIScreen.main.bounds.height)
            
            imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: leadingOffset).isActive = true
            imageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: topOffset).isActive = true
        }
        
        self.backgroundImage.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.backgroundImage.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.backgroundImage.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.backgroundImage.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        
        self.titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30).isActive = true
        self.titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        
        self.logoImageView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 15).isActive = true
        self.logoImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        
        
        leadingLineView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        leadingLineView.trailingAnchor.constraint(equalTo: self.logoImageView.leadingAnchor, constant: -10).isActive = true
        leadingLineView.centerYAnchor.constraint(equalTo: self.logoImageView.centerYAnchor).isActive = true
        
        trailingLineView.leadingAnchor.constraint(equalTo: self.logoImageView.trailingAnchor, constant: 10).isActive = true
        trailingLineView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        trailingLineView.centerYAnchor.constraint(equalTo: self.logoImageView.centerYAnchor).isActive = true
        
        
        self.emailTextField = self.inputTextField
        self.codeTextField = self.inputTextField
        
        self.emailTextField?.keyboardType = .emailAddress
        self.codeTextField?.autocapitalizationType = .none
        self.codeTextField?.autocorrectionType = .no
        self.emailTextField?.autocorrectionType = .no
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.baseWritingDirection = .rightToLeft
        paragraph.alignment = .center
        
        self.codeTextField?.attributedPlaceholder = NSAttributedString(string: "کد تخفیف (ضروری نیست)",
                                                                       attributes: [NSForegroundColorAttributeName: UIColor.white , NSParagraphStyleAttributeName: paragraph])
        
        self.fieldsStackView.addArrangedSubview(self.emailTextField!)
        self.fieldsStackView.addArrangedSubview(self.codeTextField!)
        self.fieldsStackView.addArrangedSubview(buyButton)
        self.fieldsStackView.addArrangedSubview(noButton)
        
        self.emailTextField?.widthAnchor.constraint(equalTo: fieldsStackView.widthAnchor).isActive = true
        self.codeTextField?.widthAnchor.constraint(equalTo: fieldsStackView.widthAnchor).isActive = true
        self.buyButton.widthAnchor.constraint(equalTo: fieldsStackView.widthAnchor).isActive = true
        self.noButton.widthAnchor.constraint(equalTo: fieldsStackView.widthAnchor).isActive = true
        
        let emailImageView = self.iconImageView
        let codeImageView = self.iconImageView
        
        codeImageView.image = UIImage(named: "ic_local_offer")
        
        self.view.addSubview(emailImageView)
        self.view.addSubview(codeImageView)
        
        emailImageView.leadingAnchor.constraint(equalTo: (self.emailTextField?.leadingAnchor)!).isActive = true
        emailImageView.centerYAnchor.constraint(equalTo: (self.emailTextField?.centerYAnchor)!).isActive = true
        //        emailImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        //        emailImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        codeImageView.leadingAnchor.constraint(equalTo: (self.codeTextField?.leadingAnchor)!).isActive = true
        codeImageView.centerYAnchor.constraint(equalTo: (self.codeTextField?.centerYAnchor)!).isActive = true
        //        codeImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        //        codeImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let bottomLine = self.lineView
        
        self.view.addSubview(bottomLine)
        self.view.addSubview(self.bottomStackView)
        //        self.view.addSubview(self.movieStackView)
        //        self.view.addSubview(movieButton)
        
        self.bottomStackView.addArrangedSubview(self.supportButton)
        self.bottomStackView.addArrangedSubview(self.supportLabel)
        
        //        self.movieStackView.addArrangedSubview(self.movieImageView)
        //        self.movieStackView.addArrangedSubview(self.movieLabel)
        
        bottomLine.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 17).isActive = true
        bottomLine.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -17).isActive = true
        bottomLine.bottomAnchor.constraint(equalTo: self.bottomStackView.topAnchor, constant: -12).isActive = true
        
        self.bottomStackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -12).isActive = true
        self.bottomStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive
            = true
        
        //        self.movieStackView.bottomAnchor.constraint(equalTo: bottomLine.topAnchor, constant: -17).isActive = true
        //        self.movieStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        //        self.movieStackView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        //        self.movieButton.bottomAnchor.constraint(equalTo: bottomLine.topAnchor, constant: -17).isActive = true
        //        self.movieButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        //        self.movieButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        //        self.movieButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        self.view.addSubview(self.loadingActivityIndicator)
        
        self.loadingActivityIndicator.centerXAnchor.constraint(equalTo: self.buyButton.centerXAnchor).isActive = true
        self.loadingActivityIndicator.centerYAnchor.constraint(equalTo: self.buyButton.centerYAnchor).isActive = true
        
        
        self.fieldsStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 25).isActive = true
        self.fieldsStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -25).isActive = true
        self.fieldsStackView.topAnchor.constraint(equalTo: self.logoImageView.bottomAnchor, constant: 30).isActive = true
        self.fieldsStackView.bottomAnchor.constraint(equalTo: bottomLine.topAnchor).isActive = true
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        self.buyButton.addTarget(self, action: #selector(buyButtonTapped), for: .touchUpInside)
        
        self.supportButton.addTarget(self, action: #selector(supportButtonTapped), for: .touchUpInside)
        
        //        view.addSubview(closeButton)
        //        closeButton.frame = CGRect(x: 20, y: 38, width: 18, height: 22)
        self.noButton.addTarget(self, action: #selector(NoTapped), for: .touchUpInside)
    }
    
    
    @objc func supportButtonTapped() {
        let telegramHooks = "tg://resolve?domain=App_Launcher"
        let telegramUrl = NSURL(string: telegramHooks)
        if UIApplication.shared.canOpenURL(telegramUrl! as URL)
        {
            UIApplication.shared.openURL(telegramUrl! as URL)
            
        } else {
            
        }
    }
    
    @objc func movieButtonTapped() {
        print("movie tapped!")
        let controller = UINavigationController(rootViewController: LicenseViewController())
        self.present(controller, animated: true, completion: nil)
    }
    
    @objc func buyButtonTapped() {
        self.buyButton.setTitle("", for: .normal)
        self.loadingActivityIndicator.startAnimating()
        
        guard let email = emailTextField?.text else { return }
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if emailTest.evaluate(with: email) {
            LicenseHelper.getInstance(delegate: nil).buy(email: email, code: codeTextField?.text, completion: { (success) in
                
                self.buyButton.setTitle("خرید برنامه", for: .normal)
                self.loadingActivityIndicator.stopAnimating()
                
                if success {
                    //
                } else {
                    self.showMessage(text: "مشکلی رخ داده است")
                }
            })
        } else {
            let alert = UIAlertController(title: "مشکل در ورود اطلاعات", message: "ایمیل به درستی وارد نشده است", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "باشه", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            self.buyButton.setTitle("خرید برنامه", for: .normal)
            self.loadingActivityIndicator.stopAnimating()
        }
    }
    
    private func showMessage(text: String) {
        
    }
    
    func image(fromLayer layer: CALayer) -> UIImage {
        UIGraphicsBeginImageContext(layer.frame.size)
        
        layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        
        return outputImage!
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserDefaults.standard.bool(forKey: "another-device-use-this-code") {
            self.showMessage(text: "در دستگاه دیگری با این کد وارد شده‌اید.")
            UserDefaults.standard.set(false, forKey: "another-device-use-this-code")
        }
    }
    
}
class TextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 25);
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}
