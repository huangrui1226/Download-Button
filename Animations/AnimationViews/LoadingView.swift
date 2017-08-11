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
    
    // 加载进度
    var progress: CGFloat = 0.5
    
    // 波浪的振幅，随着progress的增大而变小
    var waveScale: CGFloat { return (1 - progress) * 0.1 > 0.025 ? 0.025 : (1 - progress) * 0.05 }
    
    var waveSpeed: CGFloat = 3                                        // 波浪平移速度
    var waveTopPostition: CGFloat = 0.0                               // 当前波峰位置，波谷位置距离波峰控件宽度的一半，整个波形是个正弦曲线
    var waveLayer = CAShapeLayer()
    var gradientLayer = CAGradientLayer()
    
    var bubbleLayers: [CAShapeLayer] = []                             // 存放泡泡的layer数组
    
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
        
        // 让动画随着屏幕刷新而刷新
        let displayLink = CADisplayLink(target: self, selector: #selector(updateWave))
        displayLink.add(to: RunLoop.main, forMode: .defaultRunLoopMode)
    }
    
    func start() {
    }

    // 根据当前 progress 和 波峰位置 绘制波浪曲线
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
    
    // 绘制背景圆圈
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
    
    // 绘制初始波浪
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
        
        // 设置波浪的 Path 为 gradientLayer 的 mask，使其拥有渐变背景色
        gradientLayer.mask = waveLayer
        layer.addSublayer(gradientLayer)
    }
    
    // 添加气泡
    func addBubble() {
        
        // 进度大于0.8或者等于0时不出现气泡
        if progress >= 0.8 || progress <= 0.0 {
            return
        }
        
        // 气泡半径的极值
        let bubbleMinSize: CGFloat = 4
        let bubbleMaxSize: CGFloat = 4 + 12 * progress
        
        // 气泡半径范围 4 ～ 12
        let bubbleSize: CGFloat = bubbleMinSize + (bubbleMaxSize - bubbleMinSize) * (CGFloat(arc4random() % 100) / 100.0)
        
        let bubble = UIBezierPath()
        
        // 气泡间的水平间距， 边界距离小于1.2倍气泡最大半径的地方不出现气泡，避免气泡越界（简化方法，实际应该计算气泡到圆边界的距离，但是过于麻烦）
        let bubbleInterval: CGFloat = (width - bubbleMaxSize * 1.2 * 2) / 20
        
        // 当前 progress 下，气泡起点的水平线与圆边界的左边交点的 x 值
        let radiusSquare = radius * radius
        let startX = radius - CGFloat(sqrt(radiusSquare - fabs(radius * (1 - 2 * progress)) * fabs(radius * (1 - 2 * progress))))
        
        if radius - startX < bubbleMaxSize * 1.2 { // 距离小于泡泡的最大宽度，则不出现泡泡
            return
        }
        
        // 当前 progress 下， 气泡可能出现的水平位置的个数
        let horizontalBubbles = UInt32((sqrt(radiusSquare - fabs(radius * (1 - 2 * progress)) * fabs(radius * (1 - 2 * progress))) - 2 * bubbleMaxSize) * 2 / bubbleInterval)

        // 气泡的 center
        let center = CGPoint(x: startX + bubbleMaxSize + CGFloat(arc4random() % horizontalBubbles) * bubbleInterval + bubbleInterval / 2, y: (1 - progress + waveScale) * height)
        bubble.addArc(withCenter: center, radius: bubbleSize, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        bubble.fill()
        
        // 绘制气泡
        let bubbleLayer = CAShapeLayer()
        bubbleLayers.append(bubbleLayer)
        bubbleLayer.frame = bounds
        bubbleLayer.path = bubble.cgPath
        bubbleLayer.fillColor = UIColor.init(red: 0.000, green: 0.500, blue: 1.000, alpha: 1.0).cgColor
        layer.insertSublayer(bubbleLayer, at: 0)
        
        // 运动轨迹穿过圆心的气泡运动距离最长，即 totalHeight , 距离为波谷到圆圈顶部的长度
        let totalHeight = (1 - progress + waveScale) * height
        
        // 气泡的实际运动距离，（上弹到圆圈边缘）
        var toValue: CGFloat = 0
        
        // 勾股定理，算出气泡与圆心的垂直距离
        let a = sqrt(radius * radius - fabs(radius - center.x) * fabs(radius - center.x))
        if totalHeight > radius {
            toValue = totalHeight - radius + a
        } else {
            toValue = a - radius + totalHeight
        }
        
        // 气泡弹出和下落动画
        let positionCoe: CGFloat = (0.5 + 0.5 * (bubbleSize - bubbleMinSize) / (bubbleMaxSize - bubbleMinSize))
        let animation = CAKeyframeAnimation(keyPath: "position.y")
        animation.delegate = self
        animation.values = [
            height * 0.5,
            height * 0.5 - toValue * positionCoe + bubbleSize,
            height * 0.5
        ]
        animation.keyTimes = [0, 0.5, 1]
        animation.duration = TimeInterval(1.2 + 1.8 * (1 - progress))
        animation.timingFunctions = [CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseOut)]
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        bubbleLayer.add(animation, forKey: "bubble")
    }
    
    @objc func updateWave() {
        waveTopPostition += waveSpeed
        
        // 气泡出现几率 3%
        if arc4random() % 100 < 3 {
            addBubble()
        }
        
        if waveTopPostition > width {
            waveTopPostition -= width
        }
        waveLayer.path = getWavePath()
        let start = NSNumber(value: Float(1 - progress - waveScale))
        gradientLayer.locations = [start, 1]
    }
    
}

extension LoadingView: CAAnimationDelegate {
    
    // 动画结束，移除气泡
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
