//
//  BoostButtonView.swift
//  ARMario
//
//  Created by Roman Sentsov on 17.02.2018.
//  Copyright © 2018 Roman Sentsov. All rights reserved.
//

import UIKit

@IBDesignable
class BoostButtonView: UIButton {
    
    private let circleLayer = CAShapeLayer()
    private let lineWidth: CGFloat = 4
    
    private let redColor = UIColor(red: 1, green: 0, blue: 30 / 255, alpha: 1)
    private let grayColor = UIColor(white: 181 / 255, alpha: 1)
    
    private let timeInterval: Int = 1
    private let refreshSeconds: Int = 5
    private var currentTime: Int = 0
    
    private var timer: Timer?

    override func awakeFromNib() {
        backgroundColor = grayColor
        layer.masksToBounds = true
        layer.addSublayer(circleLayer)
        configureLabel()
        
        addTarget(self, action: #selector(touchDown), for: .touchDown)
        addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
        addTarget(self, action: #selector(touchUpOutside), for: .touchUpOutside)
    }
    
    override func draw(_ rect: CGRect) {
        layer.cornerRadius = frame.width / 2
    
        circleLayer.path = arcPath.cgPath
        circleLayer.fillColor = nil
        circleLayer.strokeColor = redColor.cgColor
        circleLayer.lineWidth = lineWidth
    }
    
    private func configureLabel() {
        addSubview(boostLabel)
        boostLabel.translatesAutoresizingMaskIntoConstraints = false
        let top = NSLayoutConstraint(item: boostLabel, attribute: .top, relatedBy: .equal,
                                     toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: boostLabel, attribute: .bottom, relatedBy: .equal,
                                     toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        let left = NSLayoutConstraint(item: boostLabel, attribute: .left, relatedBy: .equal,
                                     toItem: self, attribute: .left, multiplier: 1, constant: 0)
        let right = NSLayoutConstraint(item: boostLabel, attribute: .right, relatedBy: .equal,
                                     toItem: self, attribute: .right, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([top, bottom, left, right])
    }
    
    private func activateBoost() {
        isEnabled = false
        let refreshTimer = Timer(timeInterval: TimeInterval(timeInterval),
                      target: self,
                      selector: #selector(timerTriggered),
                      userInfo: nil,
                      repeats: true)
        RunLoop.current.add(refreshTimer, forMode: .defaultRunLoopMode)
        timer = refreshTimer
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = CFTimeInterval(refreshSeconds + 1)
        animation.fromValue = 0
        animation.toValue = 1
        circleLayer.add(animation, forKey: nil)
        
        boostLabel.text = String(refreshSeconds)
    }
    
    private func refresh() {
        isEnabled = true
        timer?.invalidate()
        timer = nil
        currentTime = 0
        boostLabel.text = "BOOST"
    }
    
    @objc private func timerTriggered() {
        currentTime += timeInterval
        boostLabel.text = String(refreshSeconds - currentTime)
        
        if currentTime >= refreshSeconds {
            refresh()
            return
        }
    }
    
    @objc private func touchDown() {
        UIView.animate(withDuration: 0.2) {
            self.alpha = 0.4
        }
    }
    
    @objc private func touchUpInside() {
        UIView.animate(withDuration: 0.2) {
            self.alpha = 1
        }
        activateBoost()
    }
    
    @objc private func touchUpOutside() {
        UIView.animate(withDuration: 0.2) {
            self.alpha = 1
        }
    }
    
    lazy var boostLabel: UILabel = {
        let label = UILabel()
        label.textColor = redColor
        label.text = "BOOST"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    private var arcPath: UIBezierPath {
        return UIBezierPath(arcCenter: viewCenter,
                            radius: frame.width / 2 - lineWidth / 2,
                            startAngle: -CGFloat.pi / 2,
                            endAngle: CGFloat.pi * 2,
                            clockwise: true)
    }
    
    private var viewCenter: CGPoint {
        return CGPoint(x: frame.width / 2, y: frame.height / 2)
    }
}
