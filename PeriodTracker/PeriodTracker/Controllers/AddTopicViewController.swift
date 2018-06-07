//
//  AddTopicViewController.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 12/26/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit
import RealmSwift

class AddTopicViewController: UIViewController , UITextViewDelegate {
    let width = UIScreen.main.bounds.width
    var category: String?
    let backgroundStackView: UIStackView = {
        let view = UIStackView()
        view.backgroundColor = UIColor.uicolorFromHex(rgbValue: 0xAAAE7F)
        view.heightAnchor.constraint(equalToConstant: 440).isActive = true
        view.axis = .vertical
        view.spacing = 7
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 0
        imageView.layer.borderColor = UIColor.uicolorFromHex(rgbValue: 0xb3b3b3).cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "discussion")
        return imageView
    }()
    
    let categoryStackView: UIStackView = {
        let sv = UIStackView()
        sv.backgroundColor = .clear
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.spacing = 16
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let pregnantButton: UIButton = {
        let button = UIButton()
        button.setTitle("بارداری", for: .normal)
        button.setTitleColor(Colors.darkToosi, for: .normal)
        button.backgroundColor = .white
//        button.backgroundColor = Colors.niceBlue
        button.titleLabel?.font(.IRANYekanBold)
        button.layer.cornerRadius = 6
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = 0
        return button
    }()
    
    let sickButton: UIButton = {
        let button = UIButton()
        button.setTitle("بیماری ها", for: .normal)
        button.setTitleColor(Colors.darkToosi, for: .normal)
        button.backgroundColor = .white
//        button.backgroundColor = Colors.niceYellow
        button.layer.cornerRadius = 6
        button.titleLabel?.font(.IRANYekanBold)
        button.tag = 1

        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let periodButton: UIButton = {
        let button = UIButton()
        button.setTitle("قاعدگی", for: .normal)
        button.setTitleColor(Colors.darkToosi, for: .normal)
        button.backgroundColor = .white
//        button.backgroundColor = Colors.niceRed
        button.layer.cornerRadius = 6
        button.titleLabel?.font(.IRANYekanBold)
        button.tag = 2
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let moreButton: UIButton = {
        let button = UIButton()
        button.setTitle("متفرقه", for: .normal)
        button.setTitleColor(Colors.darkToosi, for: .normal)
        button.backgroundColor = .white
        button.tag = 3

//        button.backgroundColor = Colors.niceGreen
        button.layer.cornerRadius = 6
        button.titleLabel?.font(.IRANYekanBold)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let subjectTextField: UITextField = {
        let textField = UITextField()
        textField.font(.IRANSans)
        textField.placeholder = "عنوان"
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 3, height: textField.frame.height))
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 3, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.rightViewMode = .always
        textField.textColor = .lightGray
        textField.textAlignment = .right
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 5
        textField.layer.borderWidth = 0
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let contentTextField: UITextView = {
        let textField = UITextView()
        textField.font(.IRANSans)
        textField.text = "متن سوال شما..."
        textField.textColor = UIColor.lightGray
        textField.heightAnchor.constraint(equalToConstant: 200).isActive = true
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 5
        textField.layer.borderWidth = 0
        textField.textAlignment = .right
        
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let logLabel: UILabel = {
        let label = UILabel()
        label.font(.IRANYekanBold)
        label.textColor = .red
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        self.title = "افزودن موضوع جدید"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "انصراف", style: .done, target: self, action: #selector(onCancelTapped))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "ایجاد", style: .done, target: self, action: #selector(onCreateTapped))
        
        self.navigationItem.rightBarButtonItem?.tintColor = Colors.accentColor
        self.navigationItem.leftBarButtonItem?.tintColor = Colors.accentColor
        
        self.view.backgroundColor = UIColor.uicolorFromHex(rgbValue: 0xAAAE7F)

        self.view.addSubview(backgroundStackView)
        self.view.addSubview(categoryStackView)
        
        self.backgroundStackView.addArrangedSubview(imageView)
        self.backgroundStackView.addArrangedSubview(categoryStackView)
        self.backgroundStackView.addArrangedSubview(subjectTextField)
        self.backgroundStackView.addArrangedSubview(contentTextField)
        self.backgroundStackView.addArrangedSubview(logLabel)
        
        self.categoryStackView.addArrangedSubview(pregnantButton)
        self.categoryStackView.addArrangedSubview(sickButton)
        self.categoryStackView.addArrangedSubview(periodButton)
        self.categoryStackView.addArrangedSubview(moreButton)

        
        self.backgroundStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 7).isActive = true
        self.backgroundStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -7).isActive = true
        self.backgroundStackView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor , constant: 7).isActive = true
        
        self.subjectTextField.leadingAnchor.constraint(equalTo: self.backgroundStackView.leadingAnchor).isActive = true
        self.subjectTextField.trailingAnchor.constraint(equalTo: self.backgroundStackView.trailingAnchor).isActive = true
        
        self.contentTextField.leadingAnchor.constraint(equalTo: self.backgroundStackView.leadingAnchor).isActive = true
        self.contentTextField.trailingAnchor.constraint(equalTo: self.backgroundStackView.trailingAnchor).isActive = true
        
        self.imageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        self.contentTextField.delegate = self
        
//        self.categoryStackView.topAnchor.constraint(equalTo: backgroundStackView.bottomAnchor, constant: 8).isActive = true
        self.categoryStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 7).isActive = true
        self.categoryStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -7).isActive = true
        self.categoryStackView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        setupButton()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= 170
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += 170
            }
        }
    }
    
    func setupButton() {
        pregnantButton.addTarget(self, action: #selector(onButtonTapped), for: .touchUpInside)
        sickButton.addTarget(self, action: #selector(onButtonTapped), for: .touchUpInside)
        periodButton.addTarget(self, action: #selector(onButtonTapped), for: .touchUpInside)
        moreButton.addTarget(self, action: #selector(onButtonTapped), for: .touchUpInside)
    }
    
    @objc func onButtonTapped(sender: UIButton) {
        pregnantButton.backgroundColor = .white
        pregnantButton.setTitleColor(Colors.darkToosi, for: .normal)
        sickButton.backgroundColor = .white
        sickButton.setTitleColor(Colors.darkToosi, for: .normal)
        periodButton.backgroundColor = .white
        periodButton.setTitleColor(Colors.darkToosi, for: .normal)
        moreButton.backgroundColor = .white
        moreButton.setTitleColor(Colors.darkToosi, for: .normal)

        if sender.tag == 0 {
            pregnantButton.backgroundColor = Colors.niceBlue
            pregnantButton.setTitleColor(.white, for: .normal)
            category = "pregnant"
        } else if sender.tag == 1 {
            sickButton.backgroundColor = Colors.niceYellow
            sickButton.setTitleColor(.white, for: .normal)
            category = "sick"
        }else if sender.tag == 2 {
            periodButton.backgroundColor = Colors.niceRed
            periodButton.setTitleColor(.white, for: .normal)
            category = "period"
        } else {
            moreButton.backgroundColor = Colors.niceGreen
            moreButton.setTitleColor(.white, for: .normal)
            category = "more"
        }
    }
    
    @objc func onCancelTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func onCreateTapped() {
        hideKeyboardWhenTappedAround()
        guard let subject = subjectTextField.text , subject != "" else {
            logLabel.text = "فیلد عنوان خالی است"
            return
        }
        guard let content = contentTextField.text , content != "" , content != "متن سوال شما..." else {
            logLabel.text = "فیلد سوال خالی است"
            return
        }
        
        guard let category = category, category != "" else {
            logLabel.text = "یکی از دسته بندی ها را انتخاب کنید"
            return
        }
        
        let realm = try! Realm()
        if let user = realm.objects(User.self).last {
        
            let parameters: Dictionary<String,Any> = [
                "subject" : subject,
                "content" : content,
                "user_id" : user.user_id,
                "category" : category
            ]
            
            Http().request(endpoint: "topic", method: .POST, parameters: parameters, completionHandler: { (data, response, error) in
                if let data = data {
                    do {
                        let response = try JSONDecoder().decode(Success.self, from: data)
                        if response.success == 1 {
                            DispatchQueue.main.async {
                                self.dismiss(animated: true, completion: nil)
                            }
                        } else {
                            self.logLabel.text = "دوباره تلاش کنید..."
                        }
                    } catch {
                        self.logLabel.text = "دوباره تلاش کنید..."
                    }
                } else {
                    self.logLabel.text = "دوباره تلاش کنید..."
                }
            })
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.characters.count // for Swift use count(newText)
        return numberOfChars < 200;
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "متن سوال شما..."
            textView.textColor = UIColor.lightGray
        }
    }
}
