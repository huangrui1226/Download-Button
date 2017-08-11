//
//  LoadingView.swift
//  Animations
//
//  Created by 黄瑞 on 2017/8/10.
//  Copyright © 2017年 黄瑞. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    
    var width: CGFloat { return self.frame.size.width }
    var height: CGFloat { return self.frame.size.height }
    var radius: CGFloat { return self.frame.size.width > self.frame.size.height ? self.frame.size.height / 2 : self.frame.size.width / 2 }
    var progress: CGFloat = 0.5
    
    // 波浪的振幅，随着progress的增大而变小
    var waveScale: CGFloat { return (1 - progress) * 0.1 > 0.025 ? 0.025 : (1 - progress) * 0.05 }
    
    var waveSpeed: CGFloat = 3                                        // 波浪平移速度
    var waveTopPostition: CGFloat = 0.0                               // 当前波峰位置，波谷位置距离波峰控件宽度的一半
    var waveLayer = CAShapeLayer()
    
    var bubbleLayers: [CAShapeLayer] = []                             // 存放泡泡的layer数组
    
    var gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
        
        setupBgCircle()
        setupWave()
        let displayLink = CADisplayLink(target: self, selector: #selector(updateWave))
        displayLink.add(to: RunLoop.main, forMode: .defaultRunLoopMode)
    }
    
    func start() {
    }

    func getWavePath() -> CGPath {
        
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        
        for i in (0..<Int(width)).filter({$0 % 2 == 0}) {
            path.addLine(to: CGPoint(x: CGFloat(i), y: (1 - progress + waveScale * sin((CGFloat(i) - waveTopPostition) / width * CGFloat.pi * 2)) * height))
        }
        path.close()
        return path.cgPath
    }
    
    func setupBgCircle() {
        
        // 绘制圆圈
        let path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: width / 2, y: height / 2), radius: radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        path.fill()
        
        let bgLayer = CAShapeLayer()
        bgLayer.lineCap = kCALineCapRound
        bgLayer.lineJoin = kCALineJoinRound
        bgLayer.path = path.cgPath
        bgLayer.fillColor = UIColor(white: 1.0, alpha: 0.1).cgColor
        layer.addSublayer(bgLayer)
    }
    
    func setupWave() {
        
        waveLayer.lineCap = kCALineCapRound
        waveLayer.lineJoin = kCALineJoinRound
        waveLayer.path = getWavePath()
        waveLayer.strokeColor = UIColor.red.cgColor
        layer.addSublayer(waveLayer)
        
        gradientLayer.colors = [
            UIColor.init(red: 0.000, green: 0.500, blue: 1.000, alpha: 1.0).cgColor,
            UIColor.purple.cgColor,
        ]
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = width / 2
        gradientLayer.masksToBounds = true
        gradientLayer.mask = waveLayer
        layer.addSublayer(gradientLayer)
    }
    
    // 添加起泡
    func addBubble() {
        let bubble = UIBezierPath()
        let bubbleInterval: CGFloat = width / 32
        
        let radiusSquare = radius * radius
        let startX = radius - CGFloat(sqrt(radiusSquare - fabs(radius - radius * progress) * fabs(radius - radius * progress)))
        let horizontalBubbles = UInt32(sqrt(radiusSquare - fabs(radius - radius * progress) * fabs(radius - radius * progress)) * 2 / bubbleInterval)

        let center = CGPoint(x: startX + CGFloat(arc4random() % horizontalBubbles) * bubbleInterval + bubbleInterval / 2, y: (1 - progress + waveScale) * height)
        bubble.addArc(withCenter: center, radius: 4, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        bubble.fill()
        
        let bubbleLayer = CAShapeLayer()
        bubbleLayers.append(bubbleLayer)
//        bubbleLayer.backgroundColor = UIColor.init(white: 1.0, alpha: 0.2).cgColor
        bubbleLayer.frame = bounds
        bubbleLayer.path = bubble.cgPath
        bubbleLayer.fillColor = UIColor.init(red: 0.000, green: 0.500, blue: 1.000, alpha: 1.0).cgColor
        layer.insertSublayer(bubbleLayer, at: 0)
        
        let totalHeight = (1 - progress + waveScale) * height
        var toValue: CGFloat = 0
        let a = sqrt(radius * radius - fabs(radius - center.x) * fabs(radius - center.x))
        if totalHeight > radius {
            toValue = totalHeight - radius + a
        } else {
            toValue = a - radius + totalHeight
        }
        
        let animation = CAKeyframeAnimation(keyPath: "position.y")
        animation.delegate = self
        animation.values = [height * 0.5, height * 0.5 - toValue, height * 0.5]
        animation.keyTimes = [0, 0.5, 1]
        animation.duration = 1.0
        animation.timingFunctions = [CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseOut)]
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        bubbleLayer.add(animation, forKey: "bubble")
    }
    
    @objc func updateWave() {
        waveTopPostition += waveSpeed
        if waveTopPostition > width {
            waveTopPostition -= width
            addBubble()
        }
        waveLayer.path = getWavePath()
        let start = NSNumber(value: Float(1 - progress - waveScale))
        gradientLayer.locations = [start, 1]
    }
    
}

extension LoadingView: CAAnimationDelegate {

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        for i in 0..<bubbleLayers.count {
            let bubbleLayer = bubbleLayers[i]
            if anim == bubbleLayer.animation(forKey: "bubble") {
                bubbleLayer.removeFromSuperlayer()
                bubbleLayers.remove(at: i)
                break
            }
        }
    }
}
