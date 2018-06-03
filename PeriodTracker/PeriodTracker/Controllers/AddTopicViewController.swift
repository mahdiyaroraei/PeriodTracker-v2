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
    
    let backgroundStackView: UIStackView = {
        let view = UIStackView()
        view.backgroundColor = .lightGray
        view.heightAnchor.constraint(equalToConstant: 260).isActive = true
        view.axis = .vertical
        view.spacing = 7
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        
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
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.textAlignment = .right
        
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let logLabel: UILabel = {
        let label = UILabel()
        label.font(.IRANYekanBold)
        label.textColor = .red
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "افزودن موضوع جدید"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "انصراف", style: .done, target: self, action: #selector(onCancelTapped))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "ایجاد", style: .done, target: self, action: #selector(onCreateTapped))
        
        self.navigationItem.rightBarButtonItem?.tintColor = Colors.accentColor
        self.navigationItem.leftBarButtonItem?.tintColor = Colors.accentColor
        
        self.view.backgroundColor = UIColor.lightGray

        self.view.addSubview(backgroundStackView)
        self.backgroundStackView.addArrangedSubview(subjectTextField)
        self.backgroundStackView.addArrangedSubview(contentTextField)
        self.backgroundStackView.addArrangedSubview(logLabel)
        
        
        self.backgroundStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 7).isActive = true
        self.backgroundStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -7).isActive = true
        self.backgroundStackView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor , constant: 7).isActive = true
        
        self.subjectTextField.leadingAnchor.constraint(equalTo: self.backgroundStackView.leadingAnchor).isActive = true
        self.subjectTextField.trailingAnchor.constraint(equalTo: self.backgroundStackView.trailingAnchor).isActive = true
        
        self.contentTextField.leadingAnchor.constraint(equalTo: self.backgroundStackView.leadingAnchor).isActive = true
        self.contentTextField.trailingAnchor.constraint(equalTo: self.backgroundStackView.trailingAnchor).isActive = true
        
        self.contentTextField.delegate = self
    }
    
    @objc func onCancelTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func onCreateTapped() {
        
        guard let subject = subjectTextField.text , subject != "" else {
            logLabel.text = "فیلد عنوان خالی است"
            return
        }
        guard let content = contentTextField.text , content != "" , content != "متن سوال شما..." else {
            logLabel.text = "فیلد سوال خالی است"
            return
        }
        
        let realm = try! Realm()
        if let user = realm.objects(User.self).last {
        
            let parameters: Dictionary<String,Any> = [
                "subject" : subject,
                "content" : content,
                "user_id" : user.user_id
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
