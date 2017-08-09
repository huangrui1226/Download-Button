//
//  DownloadButton.swift
//  Animations
//
//  Created by 黄瑞 on 2017/8/9.
//  Copyright © 2017年 黄瑞. All rights reserved.
//

import UIKit

class DownloadButton: UIButton {
    
    var lineToPointDuration = 0.5                           // 箭头竖线转换为点
    
    var isComplete: Bool = false
    
    var circleSideLength: CGFloat = 0                       // 进度指示器半径
    var lineWidth: CGFloat = 0                              // 线条宽度
    var arrowSideLength: CGFloat = 0                        // 内容视图半径（箭头和对勾）
    var buttonCenter: CGPoint = CGPoint.zero                // 按钮中心
    
    var progress: CGFloat = 0.0 {                           // 进度
        didSet {
            if progress >= 1 {
                progress = 1
            }
            circleLayer.path = getCirclePath(progress)
            checkMarkLayer.path = getCheckMarkPath(progress)
        }
    }
    var circleLayer = CAShapeLayer()                        // 进度指示器
    var verticalLineLayer = CAShapeLayer()                  // 箭头竖线 -> 弹跳的点
    var checkMarkLayer = CAShapeLayer()                     // 放有箭头底部和对勾的图层
    var circleBgLayer = CAShapeLayer()                      // 指示器底圈
    
    let verticalLinePath = UIBezierPath()                   // 箭头的竖线
    let dotPath = UIBezierPath()                            // 箭头竖线变成的点
    var checkMarkPath = UIBezierPath()                      // 对勾曲线
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addTarget(self, action: #selector(startAnimation), for: .touchUpInside)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    @objc func startAnimation() {
        if isComplete {
            setup()
        }
        
        lineToPointUpAnimation()
        arrowToLineAnimation()
    }
    
    func finishAnimation() {
        dotToCheckMark()
        isComplete = true
    }
    
    func setup() -> Void {
        
        circleLayer.removeFromSuperlayer()
        verticalLineLayer.removeFromSuperlayer()
        checkMarkLayer.removeFromSuperlayer()
        circleBgLayer.removeFromSuperlayer()
        
        circleLayer = CAShapeLayer()
        verticalLineLayer = CAShapeLayer()
        checkMarkLayer = CAShapeLayer()
        circleBgLayer = CAShapeLayer()
        
        progress = 0
        
        circleSideLength = (self.frame.size.width > self.frame.size.height ? self.frame.size.height : self.frame.size.width) * 0.8
        lineWidth = circleSideLength * 0.07
        arrowSideLength = circleSideLength * 0.6
        buttonCenter = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        
        // 圆圈背景
        let roundBgPath = UIBezierPath()
        roundBgPath.addArc(withCenter: buttonCenter, radius: circleSideLength / 2, startAngle: 0, endAngle: CGFloat.pi * 360 / 180, clockwise: true)
        
        circleBgLayer.path = roundBgPath.cgPath
        circleBgLayer.fillColor = nil
        circleBgLayer.strokeColor = UIColor(white: 1.0, alpha: 0.1).cgColor
        circleBgLayer.lineWidth = lineWidth
        circleBgLayer.lineJoin = kCALineJoinRound
        circleBgLayer.lineCap = kCALineCapRound
        layer.addSublayer(circleBgLayer)
        
        circleLayer.fillColor = nil
        circleLayer.strokeColor = UIColor.white.cgColor
        circleLayer.lineWidth = lineWidth
        circleLayer.lineJoin = kCALineJoinRound
        circleLayer.lineCap = kCALineCapRound
        layer.addSublayer(circleLayer)
        
        // 垂直线，箭头的竖线
        verticalLinePath.move(to: CGPoint(x: buttonCenter.x, y: buttonCenter.y - arrowSideLength / 2))
        verticalLinePath.addLine(to: CGPoint(x: buttonCenter.x, y: buttonCenter.y + arrowSideLength / 2))
        
        // 箭头竖线变成的点
        dotPath.move(to: CGPoint(x: buttonCenter.x, y: buttonCenter.y + arrowSideLength * 0.1))
        dotPath.addLine(to: CGPoint(x: buttonCenter.x, y: buttonCenter.y + arrowSideLength * 0.1))
        
        verticalLineLayer.path = verticalLinePath.cgPath
        verticalLineLayer.fillColor = nil
        verticalLineLayer.strokeColor = UIColor.white.cgColor
        verticalLineLayer.lineWidth = lineWidth
        verticalLineLayer.lineJoin = kCALineJoinRound
        verticalLineLayer.lineCap = kCALineCapRound
        layer.addSublayer(verticalLineLayer)
        
        // 箭头，结束时变为对勾
        checkMarkPath.lineJoinStyle = .round
        checkMarkPath.lineCapStyle = .round
        checkMarkPath.lineWidth = lineWidth
        checkMarkPath.move(to: CGPoint(x: buttonCenter.x - arrowSideLength * 0.4, y: buttonCenter.y + arrowSideLength * 0.1))
        checkMarkPath.addLine(to: CGPoint(x: buttonCenter.x, y: buttonCenter.y + arrowSideLength / 2))
        checkMarkPath.addLine(to: CGPoint(x: buttonCenter.x + arrowSideLength * 0.4, y: buttonCenter.y + arrowSideLength * 0.1))
        
        checkMarkLayer.path = checkMarkPath.cgPath
        checkMarkLayer.fillColor = nil
        checkMarkLayer.strokeColor = UIColor.white.cgColor
        checkMarkLayer.lineWidth = lineWidth
        checkMarkLayer.lineJoin = kCALineJoinRound
        checkMarkLayer.lineCap = kCALineCapRound
        layer.addSublayer(checkMarkLayer)
    }
    
    
    
    func getCirclePath(_ progess: CGFloat) -> CGPath {
        let path = UIBezierPath()
        
        path.addArc(withCenter: buttonCenter, radius: circleSideLength / 2, startAngle: -CGFloat.pi * (0.5 + progress), endAngle: -CGFloat.pi * (0.5 - progress), clockwise: true)
        
        return path.cgPath
    }
    
    func getCheckMarkPath(_ progress: CGFloat) -> CGPath {
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: buttonCenter.x - arrowSideLength * 0.4 * (1 - progress), y: buttonCenter.y + arrowSideLength * 0.1))
        path.addLine(to: CGPoint(x: buttonCenter.x + arrowSideLength * 0.4 * (1 - progress), y: buttonCenter.y + arrowSideLength * 0.1))
        
        return path.cgPath
    }
}

extension DownloadButton: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if anim == checkMarkLayer.animation(forKey: "group") {
            checkMarkLayer.removeAllAnimations()
            
            let path = UIBezierPath()
            path.move(to: CGPoint(x: buttonCenter.x - arrowSideLength * 0.4, y: buttonCenter.y + arrowSideLength * 0.1))
            path.addLine(to: CGPoint(x: buttonCenter.x, y: buttonCenter.y + arrowSideLength * 0.1))
            path.addLine(to: CGPoint(x: buttonCenter.x + arrowSideLength * 0.4, y: buttonCenter.y + arrowSideLength * 0.1))
            checkMarkLayer.path = path.cgPath
            
            Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { (timer) in
                self.progress += 0.02
                if self.progress >= 1.0 {
                    timer.invalidate()
                    self.finishAnimation()
                }
            }
        }
    }
}

//MARK: - Animations
extension DownloadButton {
    
    func arrowToLineAnimation() {
        
        let yPositions = [
            buttonCenter.y + arrowSideLength / 2,
            buttonCenter.y + arrowSideLength * 0.1 - 8,
            buttonCenter.y + arrowSideLength * 0.1 + 4,
            buttonCenter.y + arrowSideLength * 0.1 - 2,
            buttonCenter.y + arrowSideLength * 0.1 + 1,
            buttonCenter.y + arrowSideLength * 0.1,
            ]
        
        var paths: [CGPath] = []
        for i in 0..<yPositions.count {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: buttonCenter.x - arrowSideLength * 0.4, y: buttonCenter.y + arrowSideLength * 0.1))
            path.addLine(to: CGPoint(x: buttonCenter.x, y: yPositions[i]))
            path.addLine(to: CGPoint(x: buttonCenter.x + arrowSideLength * 0.4, y: buttonCenter.y + arrowSideLength * 0.1))
            paths.append(path.cgPath)
        }
        
        let keyFrameAnimation = CAKeyframeAnimation(keyPath: "path")
        keyFrameAnimation.values = paths
        keyFrameAnimation.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
        keyFrameAnimation.duration = 0.6
        keyFrameAnimation.beginTime = lineToPointDuration
        keyFrameAnimation.isRemovedOnCompletion = false
        keyFrameAnimation.fillMode = kCAFillModeForwards
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.delegate = self
        groupAnimation.animations = [keyFrameAnimation]
        groupAnimation.isRemovedOnCompletion = false
        groupAnimation.fillMode = kCAFillModeForwards
        groupAnimation.duration = keyFrameAnimation.duration + keyFrameAnimation.beginTime
        checkMarkLayer.add(groupAnimation, forKey: "group")
    }
    
    func lineToPointUpAnimation() {
        
        let keyframeAnimation = CAKeyframeAnimation(keyPath: "path")
        keyframeAnimation.values = [verticalLinePath.cgPath, dotPath.cgPath, dotPath.cgPath]
        keyframeAnimation.keyTimes = [0, 0.8, 1]
        keyframeAnimation.duration = lineToPointDuration
        keyframeAnimation.isRemovedOnCompletion = false
        keyframeAnimation.fillMode = kCAFillModeForwards
        
        let sprintAnimation = CASpringAnimation(keyPath: "position.y")
        sprintAnimation.delegate = self
        sprintAnimation.damping = 10
        sprintAnimation.toValue = -(circleSideLength / 2 + arrowSideLength * 0.1)
        sprintAnimation.duration = sprintAnimation.settlingDuration
        sprintAnimation.beginTime = keyframeAnimation.duration
        sprintAnimation.isRemovedOnCompletion = false
        sprintAnimation.fillMode = kCAFillModeForwards
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [keyframeAnimation, sprintAnimation]
        groupAnimation.isRemovedOnCompletion = false
        groupAnimation.fillMode = kCAFillModeForwards
        groupAnimation.duration = sprintAnimation.duration + keyframeAnimation.duration
        verticalLineLayer.add(groupAnimation, forKey: "group")
        
    }
    
    func dotToCheckMark() {
        checkMarkLayer.removeAllAnimations()
        
        checkMarkLayer.strokeColor = UIColor(red: 43 / 255.0, green: 172 / 255.0, blue: 95 / 255.0, alpha: 1.0).cgColor
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: buttonCenter.x - arrowSideLength * 0.35, y: buttonCenter.y + arrowSideLength * 0.05))
        path.addLine(to: CGPoint(x: buttonCenter.x, y: buttonCenter.y + arrowSideLength * 0.3))
        path.addLine(to: CGPoint(x: buttonCenter.x + arrowSideLength * 0.4, y: buttonCenter.y - arrowSideLength * 0.3))
        
        let animation = CAKeyframeAnimation(keyPath: "path")
        animation.values = [checkMarkLayer.path!, path.cgPath]
        animation.keyTimes = [0, 1.0]
        animation.duration = 0.5
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        checkMarkLayer.add(animation, forKey: "finish")
    }
}
