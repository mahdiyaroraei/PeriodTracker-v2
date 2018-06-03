//
//  ArticleFooterTableViewCell.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 8/28/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit
import Alamofire

class ArticleFooterTableViewCell: UICollectionReusableView {
    
    var article: Article! {
        didSet {
            clappingCountLabel.text = "\(article.clap!)"
        }
    }
    
    var borderView: UIView {
        get {
            let view = UIView()
            view.backgroundColor = UIColor.uicolorFromHex(rgbValue: 0xb3b3b3).withAlphaComponent(0.9)
            view.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
            view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }
    }
    
    let clapImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "clap")?.withRenderingMode(.alwaysTemplate))
        imageView.tintColor = UIColor.uicolorFromHex(rgbValue: 0x43A047)
        imageView.layer.cornerRadius = 85 / 2
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.uicolorFromHex(rgbValue: 0xb3b3b3).cgColor
        imageView.contentMode = .center
        imageView.backgroundColor = .white
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let clappingCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "IRANSansFaNum-Bold", size: 17)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let clapStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 7
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        
        self.backgroundColor = UIColor.uicolorFromHex(rgbValue: 0xf1f8ff)
        
        
        let topBorderView = borderView
        let bottomBorderView = borderView
        
        addSubview(topBorderView)
        clapStackView.addArrangedSubview(clappingCountLabel)
        clapStackView.addArrangedSubview(clapImageView)
        addSubview(clapStackView)
        addSubview(bottomBorderView)
        
        
        topBorderView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        topBorderView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bottomBorderView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        bottomBorderView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        
        clapImageView.widthAnchor.constraint(equalToConstant: 85).isActive = true
        clapImageView.heightAnchor.constraint(equalToConstant: 85).isActive = true
        
        clapStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        clapStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(clapping(gesture:)))
        clapImageView.addGestureRecognizer(longGesture)
        clapImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clappingOnce)))
    }
    
    var clappingCount = 0
    var timer: Timer?
    
    func clapping(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(handleTimer), userInfo: nil, repeats: true)
        } else if gesture.state == .ended || gesture.state == .cancelled {
            // Update clap count
            Alamofire.request("\(Config.WEB_DOMAIN)clapping/\(article.id!)/\(clappingCount)")
            article.increaseClap(count: clappingCount)
            clappingCount = 0
            timer?.invalidate()
            timer = nil
        }
    }
    
    func animationStart() {
        UIView.animate(withDuration: 0.1, animations: {
            self.clapImageView.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
        }) { (finish) in
            self.animationStop()
        }
    }
    
    func animationStop() {
        UIView.animate(withDuration: 0.1) {
            self.clapImageView.transform = CGAffineTransform.identity
        }
    }
    
    func clappingOnce() {
        // Update clap count
        Alamofire.request("\(Config.WEB_DOMAIN)clapping/\(article.id!)/\(1)")
        article.increaseClap(count: 1)
        clappingCountLabel.text = "دست خود را نگه دارید"
        vibrateWithHaptic()
    }
    
    func handleTimer(timer: Timer) {
        animationStart()
        clappingCount += 1
        clappingCountLabel.text = "\(article.clap + clappingCount)"
        vibrateWithHaptic()
    }
    
    var labelBeforAnimFrame: CGRect?
    
    private func vibrateWithHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
