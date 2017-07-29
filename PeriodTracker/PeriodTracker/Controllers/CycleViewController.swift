//
//  CycleViewController.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 7/27/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit

class CycleViewController: UIViewController {
    
    let circlePadding = 30
    
    var logButton: UIButton!
    
    var cycleLength: Int! = 40
    var degreeUnit: Double!
    var points: [CGPoint] = []
    
    var dayMarker = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        degreeUnit = 2 * Double.pi / Double(cycleLength)
        
        // Draw basic circle
        drawCircle(option: CircleOption(color: UIColor.gray, startAngle: 0, endAngle: CGFloat(Double.pi * 2)))
        
        drawCircleButton()
        
        computePoints()
        
        initDayMarkerView()
    }
    
    func initDayMarkerView() {
        dayMarker.frame.size = CGSize(width: 50, height: 50)
        dayMarker.backgroundColor = UIColor.blue
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
    }
    
    func distance(a: CGPoint, b: CGPoint) -> CGFloat {
        let xDist = a.x - b.x
        let yDist = a.y - b.y
        return CGFloat(sqrt((xDist * xDist) + (yDist * yDist)))
    }
    
    func computePoints() {
        points.removeAll()
        let centerPoint:CGPoint = view.center
        let radius = self.view.frame.width / 2 - CGFloat(circlePadding)
        let a = (Double.pi * 2) / Double (cycleLength)
        
        for i in 0 ..< cycleLength{
            
            let x = CGFloat(Double (centerPoint.x) + Double (radius) * cos(Double (i) * a - Double.pi / 2))
            let y = CGFloat(Double (centerPoint.y) + Double (radius) * sin(Double (i) * a - Double.pi / 2))
            
            points.append(CGPoint(x: x, y: y))
        }
    }
    
    func drawCircleButton() {
        let circleRadius = self.view.frame.width / 2 - CGFloat(circlePadding) - 30 - 20
        
        logButton = UIButton()
        logButton.titleLabel?.font = UIFont(name: "IRANSans(FaNum)", size: 15)
        logButton.setTitle("اطلاعات امروز را وارد کنید", for: .normal)
        logButton.titleLabel?.lineBreakMode = .byWordWrapping
        logButton.titleLabel?.textAlignment = .center
        logButton.backgroundColor = UIColor.brown
        logButton.frame.size = CGSize(width: circleRadius * 2, height: circleRadius * 2)
        logButton.addTarget(self, action: #selector(logButtonClicked(sender:)), for: .touchUpInside)
        
        self.view.addSubview(logButton)
        
        logButton.center = self.view.center
        logButton.layer.cornerRadius = circleRadius
    }
    
    func logButtonClicked(sender: UIButton) {
        print("Button tapped!")
    }

    func drawCircle(option: CircleOption) {
        let circleShapeLayer = CAShapeLayer()
        let circlePath = UIBezierPath(arcCenter: self.view.center, radius: self.view.frame.width / 2 - CGFloat(circlePadding) , startAngle: option.startAngle, endAngle: option.endAngle, clockwise: true)
        
        circleShapeLayer.path = circlePath.cgPath
        circleShapeLayer.fillColor = UIColor.clear.cgColor
        circleShapeLayer.lineWidth = 30
        circleShapeLayer.strokeColor = option.color.cgColor
        
        self.view.layer.addSublayer(circleShapeLayer)
    }

}
