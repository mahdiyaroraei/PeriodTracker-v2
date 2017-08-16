//
//  CycleViewController.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 7/27/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit
import RealmSwift

class CycleViewController: UIViewController , DayLogDelegate {
    
    let circlePadding = 30
    
    var logButton: UIButton!
    
    // TODO Change this after test
    var cycleLength: Int! = 40
    var periodLength: Int! = 7
    var degreeUnit: Double!
    var points: [CGPoint] = []
    
    var pmsRange: CountableClosedRange<Int>!
    var periodRange: CountableClosedRange<Int>!
    var fertileRange: CountableClosedRange<Int>!
    
    var dayMarker = UILabel()
    
    let calendar = Calendar(identifier: .persian)
    
    var todayPoint: CGPoint!
    @IBOutlet weak var todayButton: UIButton!
    
    let realm = try! Realm()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let setup = realm.objects(Setup.self).last {
            cycleLength = setup.cycleLength
            periodLength = setup.periodLength
        }
        
        pmsRange = cycleLength - 3...cycleLength
        periodRange = 0...periodLength + 1
        fertileRange = Utility.computeFertileRange(cycleLength)
        
        degreeUnit = 2 * Double.pi / Double(cycleLength)
        todayButton.setTitle("\(calendar.component(.day, from: Date()))", for: .normal)
        
        // Draw basic circle
        drawCircle(option: CircleOption(color: UIColor.gray, startAngle: 0, endAngle: CGFloat(Double.pi * 2)))
        
        // Draw PMS on cycle
        drawCircle(option: CircleOption(color: .white, startAngle: CGFloat(Double.pi * 2 - degreeUnit * 3), endAngle: CGFloat(Double.pi * 2)))
        
        // Draw period on cycle
        drawCircle(option: CircleOption(color: .red, startAngle: 0, endAngle: CGFloat(degreeUnit * Double(periodLength))))
        
        // Draw Fertile on cycle
        drawCircle(option: CircleOption(color: .blue, startAngle: CGFloat(degreeUnit * Double(fertileRange.min()! - 1)), endAngle: CGFloat(degreeUnit * Double(fertileRange.max()! - 1))))
        
        drawCircleButton()
        
        computePoints(fertileDayIndex: Int(ceil(Double((fertileRange.max()! + fertileRange.min()!) / 2))) - 1)
        
        initDayMarkerView()
        
        selectDay(sender: todayPoint)
    }
    
    func initDayMarkerView() {
        dayMarker.frame.size = CGSize(width: 50, height: 50)
        dayMarker.backgroundColor = UIColor.red
        dayMarker.text = "1"
        dayMarker.textAlignment = .center
        
        self.view.addSubview(dayMarker)
        
        dayMarker.center = points[0]
        dayMarker.layer.masksToBounds = true
        dayMarker.layer.cornerRadius = 25
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        selectDay(sender: touches.first!.location(in: self.view))
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        selectDay(sender: touches.first!.location(in: self.view))
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    func selectDay(sender: CGPoint) {
        var day = 1
        
        var selectedPoint : CGPoint = points[0]
        for (index ,point) in points.enumerated() {
            if distance(a: point, b: sender) < distance(a: selectedPoint, b: sender) {
                selectedPoint = point
                day = index + 1
            }
        }
        dayMarker.center = selectedPoint
        dayMarker.text = "\(day)"
        
        if periodRange.contains(day) {
            dayMarker.backgroundColor = .red
            logButton.backgroundColor = .red
        }else if fertileRange.contains(day){
            dayMarker.backgroundColor = .blue
            logButton.backgroundColor = .blue
        }else if pmsRange.contains(day){
            dayMarker.backgroundColor = .white
            logButton.backgroundColor = .white
        }else{
            dayMarker.backgroundColor = .orange
            logButton.backgroundColor = .orange
        }
        
        let date = calendar.date(byAdding: .day, value: day - 1, to: startPeriodDate)
        if date! > Date() {
            logButton.backgroundColor = .lightGray
            logButton.isEnabled = false
            
            let dateComponents = calendar.dateComponents([.year, .month , .day], from: date!)
            let dateString = "\(dateComponents.year!)/\(dateComponents.month!)/\(dateComponents.day!)"
            
            logButton.setTitle(dateString, for: .disabled)
        } else {
            logButton.isEnabled = true
            let dateComponents = calendar.dateComponents([.year, .month , .day], from: date!)
            let dateString = "\(dateComponents.year!)/\(dateComponents.month!)/\(dateComponents.day!)"
            logButton.setTitle("اطلاعات روز \(dateString) را وارد کنید", for: .normal)
            
            if calendar.isDateInToday(date!) {
                
                logButton.setTitle("اطلاعات امروز را وارد کنید", for: .normal)
            }
            CalendarViewController.selectedDate = date
        }
    }
    
    func distance(a: CGPoint, b: CGPoint) -> CGFloat {
        let xDist = a.x - b.x
        let yDist = a.y - b.y
        return CGFloat(sqrt((xDist * xDist) + (yDist * yDist)))
    }
    
    var startPeriodDate: Date!
    
    func computePoints(fertileDayIndex: Int) {
        points.removeAll()
        let centerPoint:CGPoint = view.center
        let radius = self.view.frame.width / 2 - CGFloat(circlePadding)
        let a = (Double.pi * 2) / Double (cycleLength)
        
        for i in 0 ..< cycleLength{
            let x = CGFloat(Double (centerPoint.x) + Double (radius) * cos(Double (i) * a - Double.pi / 2))
            let y = CGFloat(Double (centerPoint.y) + Double (radius) * sin(Double (i) * a - Double.pi / 2))
            
            points.append(CGPoint(x: x, y: y))
            
            // Compute satrt of this cycle
            let diffrence = calendar.dateComponents([.day], from: Date(timeIntervalSince1970: realm.objects(Setup.self).last!.startDate), to: calendar.startOfDay(for: Date())).day! % cycleLength
            startPeriodDate = calendar.date(byAdding: .day, value: -diffrence, to: calendar.startOfDay(for: Date()))
            
            if calendar.isDateInToday(calendar.date(byAdding: .day, value: i, to: startPeriodDate!)!) {
                // Today mark visible in this condition
                let todayMark = UILabel()
                
                todayMark.frame.size = CGSize(width: 53, height: 53)
                todayMark.backgroundColor = UIColor.clear
                
                self.view.addSubview(todayMark)
                
                todayPoint = points[i]
                todayMark.center = points[i]
                todayMark.layer.masksToBounds = true
                todayMark.layer.cornerRadius = 25
                todayMark.layer.borderWidth = 3
                todayMark.layer.borderColor = UIColor.green.cgColor
                
                self.view.addSubview(todayMark)
            }
            if fertileDayIndex == i {
                // Fertile mark visible in this condition
                let fertileDayMarker = UILabel()
                
                fertileDayMarker.frame.size = CGSize(width: 50, height: 50)
                fertileDayMarker.backgroundColor = UIColor.yellow
                
                self.view.addSubview(fertileDayMarker)
                
                fertileDayMarker.center = points[i]
                fertileDayMarker.layer.masksToBounds = true
                fertileDayMarker.layer.cornerRadius = 25
                
                self.view.addSubview(fertileDayMarker)
            }
        }
    }
    
    func drawCircleButton() {
        let circleRadius = self.view.frame.width / 2 - CGFloat(circlePadding) - 30 - 20
        
        logButton = UIButton()
        logButton.titleLabel?.font = UIFont(name: "IRANSansFaNum-Light", size: 19)
        logButton.setTitle("اطلاعات امروز را وارد کنید", for: .normal)
        logButton.titleLabel?.lineBreakMode = .byWordWrapping
        logButton.titleLabel?.textAlignment = .center
        logButton.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 15)
        logButton.backgroundColor = UIColor.red
        logButton.setTitleColor(.white, for: .normal)
        logButton.setTitleColor(UIColor.white.withAlphaComponent(0.7), for: .highlighted)
        logButton.frame.size = CGSize(width: circleRadius * 2, height: circleRadius * 2)
        logButton.addTarget(self, action: #selector(logButtonClicked(sender:)), for: .touchUpInside)
        
        self.view.addSubview(logButton)
        
        logButton.center = self.view.center
        logButton.layer.cornerRadius = circleRadius
    }
    
    func present(identifier: String) {
        self.tabBarController?.selectedIndex = 2
    }
    
    func logButtonClicked(sender: UIButton) {
        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "dayLogViewController"))! as! DayLogViewController
        vc.delegate = self
        
        present(vc, animated: true, completion: nil)
    }

    func drawCircle(option: CircleOption) {
        let circleShapeLayer = CAShapeLayer()
        // Should - CGFloat(Double.pi / 2) to start from top
        let circlePath = UIBezierPath(arcCenter: self.view.center, radius: self.view.frame.width / 2 - CGFloat(circlePadding) , startAngle: option.startAngle - CGFloat(Double.pi / 2), endAngle: option.endAngle - CGFloat(Double.pi / 2), clockwise: true)
        
        circleShapeLayer.path = circlePath.cgPath
        circleShapeLayer.fillColor = UIColor.clear.cgColor
        circleShapeLayer.lineWidth = 40
        circleShapeLayer.strokeColor = option.color.cgColor
        circleShapeLayer.lineCap = kCALineCapRound
        
        self.view.layer.addSublayer(circleShapeLayer)
    }

    @IBAction func todayClicked(_ sender: UIButton) {
        selectDay(sender: todayPoint)
    }
    
    @IBAction func openGuide(_ sender: Any) {
        let vc = GuideViewController()
        vc.guide = Utility.createGuideObjectFromKey(key: "cycleViewController")!
        present(vc, animated: true, completion: nil)
    }
}
