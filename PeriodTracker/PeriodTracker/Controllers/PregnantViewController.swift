//
//  PregnantViewController.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 8/1/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import SwiftyJSON

class PregnantViewController: UIViewController, UICollectionViewDelegate , UICollectionViewDelegateFlowLayout , UICollectionViewDataSource ,
SelectCellDelegate {
    
    var article: Article! {
        didSet {
            viewCountLabel.text = article.view.forrmated
            
            articleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedOnArticle)))
        }
    }
    
    func tappedOnArticle() {
        let vc = ArticlePageViewController()
        article.increaseView()
        vc.article = article
        navigationController?.pushViewController(vc, animated: true)
        navigationController?.navigationBar.isHidden = false
        
        Alamofire.request("\(Config.WEB_DOMAIN)view/\(article.id!)")
    }
    
    @IBOutlet weak var weekCollectionView: UICollectionView!
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var articleView: UIView!
    @IBOutlet weak var articleSubjectLabel: UILabel!
    
    @IBOutlet weak var viewCountLabel: UILabel!
    var pregnantImageView: UIImageView!
    var pregnantLabel: UILabel!
    
    var calendar = Calendar(identifier: .persian)
    
    public static var selectedName: String!
    
    // start of day and month
    let nowDate = Calendar.current.startOfDay(for: Date())
    
    // After select item viewDidLayoutSubviews called again for avoid scroll use this
    var scrolledFirst = false
    
    // Enable moods store to this object
    var moods: Results<Mood>!
    
    // Value type of selected mood get from database store here
    var valueTypes: [String] = []
    var selectedMood: Mood!
    
    var pregnantWeek: Int! {
        didSet {
            if pregnantWeek != -1 {
                articleSubjectLabel.text = "مقاله مربوط به هفته \(pregnantWeek!) بارداری"
                getPregnantWeekArticle()
            }
        }
    }
    
    let realm = try! Realm()
    
    // Color overlay layer on period image view
    let colorOverlayLayer = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "امروز"
        navigationController?.navigationBar.isHidden = true
        
        pregnantWeek = calendar.dateComponents([.day], from: Date(timeIntervalSince1970: Utility.latestPeriodLog()), to: Date()).day! / 7 + 1
        
        todayLabel.text = "\(String(describing: Calendar(identifier: .persian).dateComponents([.day], from: nowDate).day!))"
        
        self.weekCollectionView.dataSource = self
        self.weekCollectionView.delegate = self
        
        
        self.weekCollectionView.showsHorizontalScrollIndicator = false
        
        // For scrolling like a page and not stay at middle of item
        self.weekCollectionView.isPagingEnabled = true
        
        
        // Hide keyboard on touch outside textfield
        //        let tap = UIGestureRecognizer(target: self, action: #selector(dissmisKeyboard))
        //        view.addGestureRecognizer(tap)
        
        setupPregnantImage()
        setupPregnantLabel()
        setupPregnantLogLabel()
    }
    
    func getPregnantWeekArticle() {
        Alamofire.request("\(Config.WEB_DOMAIN)article/\(pregnantWeek!)").response { (response) in
            if let data = response.data {
                let serilizedJson = JSON(data)
                self.article = Utility.createArticleFromJSON((serilizedJson.array?[0])!)
            }
        }
    }
    
    func setupArticleViews() {
        articleView.roundCorners([.topLeft , .topRight], radius: 10)
        
        articleSubjectLabel.text = "مقاله مربوط به هفته \(pregnantWeek!) بارداری"
    }
    
    func setupPregnantLogLabel() {
        let pregnantLogButton = UIButton()
        pregnantLogButton.setTitle("ثبت جزییات", for: .normal)
        pregnantLogButton.titleLabel?.font = UIFont(name: "IRANSans(FaNum)", size: 16)
        pregnantLogButton.titleLabel?.textColor = .white
        pregnantLogButton.titleLabel?.textAlignment = .center
        pregnantLogButton.backgroundColor = .orange
        
        self.view.addSubview(pregnantLogButton)
        
        pregnantLogButton.frame.size = CGSize(width: 100, height: 35)
        pregnantLogButton.center = CGPoint(x: self.view.center.x, y: self.pregnantImageView.frame.maxY - 40)
        pregnantLogButton.layer.cornerRadius = 10
        pregnantLogButton.layer.masksToBounds = true
        pregnantLogButton.addTarget(self, action: #selector(pregnantLogButtonClicked(sender:)), for: .touchUpInside)
    }
    
    func pregnantLogButtonClicked(sender: UIButton) {
        let dayLogViewController = self.storyboard?.instantiateViewController(withIdentifier: "dayLogViewController") as! DayLogViewController
        dayLogViewController.isPregnant = true
        present(dayLogViewController , animated: true, completion: nil)
    }
    
    func setupPregnantLabel() {
        pregnantLabel = UILabel()
        pregnantLabel.textAlignment = .center
        
        let title = "بارداری: هفته \(pregnantWeek!)"
        let attributeString = NSMutableAttributedString(string: title)
        attributeString.addAttribute(NSFontAttributeName, value: UIFont(name: "IRANSansFaNum-Light", size: 20)!, range: NSRange(location: 0, length: 9))
        attributeString.addAttribute(NSFontAttributeName, value: UIFont(name: "IRANSansFaNum-Bold", size: 20)!, range: NSRange(location: 9, length: "\(pregnantWeek!)".characters.count + 5))
        attributeString.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: NSRange(location: 0, length: title.characters.count))
        
        pregnantLabel.attributedText = attributeString
        
        self.view.addSubview(pregnantLabel)
        
        pregnantLabel.frame.size = CGSize(width: pregnantImageView.frame.width, height: 25)
        pregnantLabel.center = CGPoint(x: self.view.center.x, y: self.pregnantImageView.frame.origin.y + 40)
        
    }
    
    func setupPregnantImage() {

        let centerY = (self.view.frame.height - (weekCollectionView.frame.origin.y +  weekCollectionView.frame.size.height)) / 2 + (weekCollectionView.frame.origin.y +  weekCollectionView.frame.size.height) - 85 // 40 is padding + 45 for hidden nav item
        
        pregnantImageView = UIImageView(image: UIImage(named: "pregnant\(pregnantWeek!)"))
        pregnantImageView.backgroundColor = .blue
        
        self.view.addSubview(pregnantImageView)
        
        let imageSize = self.view.frame.width - 20
        pregnantImageView.frame.size = CGSize(width: imageSize, height: imageSize)
        pregnantImageView.center = CGPoint(x: self.view.center.x, y: centerY)
        pregnantImageView.layer.masksToBounds = true
        pregnantImageView.layer.cornerRadius = imageSize / 2
        
        colorOverlayLayer.path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: pregnantImageView.frame.width, height: pregnantImageView.frame.height)).cgPath
        colorOverlayLayer.fillColor = UIColor.lightGray.cgColor
        colorOverlayLayer.opacity = 0.3
        
        pregnantImageView.layer.addSublayer(colorOverlayLayer)
    }
    func dissmisKeyboard() {
        
    }
    
    override func viewWillLayoutSubviews() {
        self.weekCollectionView.reloadData()
        
        if stackView.frame.size.height == 0 {
            return
        }
        // Add top and bottom border for stackView
        let topLineLayer = CALayer()
        topLineLayer.backgroundColor = Colors.normalCellColor.cgColor
        topLineLayer.frame = CGRect(x:-50,y: 0, width:self.view.frame.size.width + 100, height:1)
        stackView.layer.addSublayer(topLineLayer)
        
        let bottomLineLayer = CALayer()
        bottomLineLayer.backgroundColor = Colors.normalCellColor.cgColor
        bottomLineLayer.frame = CGRect(x:-50, y:stackView.frame.size.height - 1, width:stackView.frame.size.width + 100, height:1)
        stackView.layer.addSublayer(bottomLineLayer)
    }
    
    @IBOutlet weak var weekCollectionViewHeight: NSLayoutConstraint!
    // Scroll to current after layout subviews completed
    override func viewDidLayoutSubviews() {
        if !scrolledFirst {
            // Scroll to current week
            // TODO change
            // let diffrence = calendar.dateComponents([.weekOfYear], from: calendar.startOfDay(for: Date()), to: CalendarViewController.selectedDate!).weekOfYear
            
            let diffrence = calendar.dateComponents([.weekOfYear], from: calendar.startOfDay(for: Date()), to: Date()).weekOfYear
            
            self.weekCollectionView.scrollToItem(at: IndexPath(row: 25 + diffrence!, section: 0), at: .left, animated: false)
            setupArticleViews()
        }
        
        weekCollectionViewHeight.constant = (self.weekCollectionView.frame.width / 7 + 20)
        
    }
    
    @IBAction func gotoCurrentWeek(_ sender: Any) {
        self.weekCollectionView.scrollToItem(at: IndexPath(row: 25, section: 0), at: .left, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            
            // 51 week show and middle of items is currently week
            return 51
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            let cell = self.weekCollectionView.dequeueReusableCell(withReuseIdentifier: "week_cell", for: indexPath) as! WeekCollectionViewCell
            
            cell.delegate = self
            cell.isPregnant = true
            cell.weekDate = calendar.date(byAdding: .weekOfYear, value: indexPath.row - 25 , to: nowDate)
            cell.refresh()
            
            return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
            
            return CGSize(width: self.view.frame.width, height: self.weekCollectionView.frame.width / 7 + 20)
        
    }
    
    func updateTableView() {
        // Update all collection view for log new timestamp
        self.scrolledFirst = true
        self.weekCollectionView.reloadData()
        refreshPregnantViewsIfWeekChange()
    }
    
    func refreshPregnantViewsIfWeekChange() {
        let tempPregnant = calendar.dateComponents([.day], from: Date(timeIntervalSince1970: Utility.latestPeriodLog()), to: CalendarViewController.selectedDate!).day! / 7 + 1
        
        if  calendar.dateComponents([.day], from: Date(timeIntervalSince1970: Utility.latestPeriodLog()), to: CalendarViewController.selectedDate!).day! < 0 {
            colorOverlayLayer.opacity = 0.9
            pregnantLabel.font = UIFont(name: "IRANSans(FaNum)", size: 15)
            pregnantLabel.text = "در این روز هنوز باردار نیستید"
            pregnantWeek = -1
            articleView.isHidden = true
            return
        }
        articleView.isHidden = false
        colorOverlayLayer.opacity = 0.3
        
        if pregnantWeek != tempPregnant {
            pregnantWeek = tempPregnant
            pregnantImageView.image = UIImage(named: "pregnant\(pregnantWeek!)")
            
            let title = "بارداری: هفته \(pregnantWeek!)"
            let attributeString = NSMutableAttributedString(string: title)
            attributeString.addAttribute(NSFontAttributeName, value: UIFont(name: "IRANSansFaNum-Light", size: 20)!, range: NSRange(location: 0, length: 9))
            attributeString.addAttribute(NSFontAttributeName, value: UIFont(name: "IRANSansFaNum-Bold", size: 20)!, range: NSRange(location: 9, length: "\(pregnantWeek!)".characters.count + 5))
            attributeString.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: NSRange(location: 0, length: title.characters.count))
            
            pregnantLabel.attributedText = attributeString
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.weekCollectionView.reloadData()
        navigationController?.navigationBar.isHidden = true
    }
    
    func cannotSelectFuture() {
        showToast(message: "نمی‌توانید روز های آینده را انتخاب کنید!")
    }
    
    func changeTitle(title: String) {
        titleLabel.text = title
        self.title = title
    }
    
    func presentVC(id: String) {
        
    }
    
    func presentViewController(_ identifier: String) {
        let vc = storyboard?.instantiateViewController(withIdentifier: identifier)
        present(vc!, animated: true, completion: nil)
    }

}
