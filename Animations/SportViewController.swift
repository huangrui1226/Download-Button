//
//  SportViewController.swift
//  Animations
//
//  Created by 黄瑞 on 2017/8/14.
//  Copyright © 2017年 黄瑞. All rights reserved.
//

import UIKit

class SportViewController: UIViewController {
    
    let bgLayer: CAShapeLayer = CAShapeLayer()
    let extraOffset: CGFloat = 200
    
    var startX: CGFloat = 0
    var currentX: CGFloat = 0
    var offset: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.init(red: 1.000, green: 0.500, blue: 0.500, alpha: 1.0)
        
        bgLayer.frame = view.bounds
        bgLayer.lineCap = kCALineCapRound
        bgLayer.lineJoin = kCALineJoinRound
        bgLayer.fillColor = UIColor.init(red: 0.500, green: 1.000, blue: 0.500, alpha: 1.0).cgColor
        view.layer.addSublayer(bgLayer)
        
        let run_man = RuningMan()
        run_man.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        run_man.center = view.center
        view.addSubview(run_man)
        
        let tapGest = UIPanGestureRecognizer(target: self, action: #selector(tapGest(_:)))
        view.addGestureRecognizer(tapGest)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    @objc func tapGest(_ sender: UITapGestureRecognizer) {
        let touchPoint = sender.location(in: view)
        
        switch sender.state {
        case .began:
            startX = touchPoint.x
        case .changed:
            currentX = touchPoint.x
            bgLayer.path = getPath(offset: offset + (currentX - startX) * 1.3)
        case .ended:
            // 更新偏移量变量
            offset = offset + (currentX - startX) * 1.3
    
            let width = view.frame.size.width
    
            let animation = CAKeyframeAnimation(keyPath: "path")
            animation.delegate = self
            animation.duration = 0.3
            animation.keyTimes = [0, 1]
            animation.isRemovedOnCompletion = false
            animation.fillMode = kCAFillModeForwards
    
    
            if offset < (width + extraOffset) / 2 {
                if offset < width / 2 {
                    animation.keyTimes = [0, 1]
                    animation.values = [getPath(offset: offset), getPath(offset: 0)]
                } else {
                    animation.keyTimes = [0, 0.5, 1]
                    animation.values = [getPath(offset: offset), getPath(offset: width / 2), getPath(offset: 0)]
                }
                offset = 0
            } else {
                if offset < width / 2 + extraOffset {
                    animation.keyTimes = [0, 0.5, 1]
                    animation.values = [getPath(offset: offset), getPath(offset: width / 2 + extraOffset), getPath(offset: width + extraOffset)]
                } else {
                    animation.keyTimes = [0, 1]
                    animation.values = [getPath(offset: offset), getPath(offset: width + extraOffset)]
                }
                offset = width + extraOffset
            }
    
    
            bgLayer.add(animation, forKey: "path")
            
        default:
            print("default")
        }
    }
        
    // 根据偏移量画出曲线，范围是 width + extraOffset
    func getPath(offset: CGFloat) -> CGPath {
        let path = UIBezierPath()
        let width = view.frame.size.width
        let height = view.frame.size.height
        
        path.move(to: CGPoint.zero)
        
        if offset < width / 2 {
            path.addLine(to: CGPoint(x: offset - extraOffset / 2, y: 0))
            path.addCurve(to: CGPoint(x: offset, y: height / 2), controlPoint1: CGPoint(x: offset - extraOffset / 2, y: height / 3), controlPoint2: CGPoint(x: offset, y: height / 4))
            path.addCurve(to: CGPoint(x: offset - extraOffset / 2, y: height), controlPoint1: CGPoint(x: offset, y: height * 3 / 4), controlPoint2: CGPoint(x: offset - extraOffset / 2, y: height * 2 / 3))
            path.addLine(to: CGPoint(x: 0, y: height))
        } else if offset > width / 2 + extraOffset {
            path.addLine(to: CGPoint(x: offset - extraOffset + extraOffset / 2, y: 0))
            path.addCurve(to: CGPoint(x: offset - extraOffset, y: height / 2), controlPoint1: CGPoint(x: offset - extraOffset + extraOffset / 2, y: height / 3), controlPoint2: CGPoint(x: offset - extraOffset, y: height / 4))
            path.addCurve(to: CGPoint(x: offset - extraOffset + extraOffset / 2, y: height), controlPoint1: CGPoint(x: offset - extraOffset, y: height * 3 / 4), controlPoint2: CGPoint(x: offset - extraOffset + extraOffset / 2, y: height * 2 / 3))
            path.addLine(to: CGPoint(x: 0, y: height))
        } else {
            let xPosition = offset - extraOffset / 2
            if xPosition < width / 2 {
                path.addLine(to: CGPoint(x: xPosition, y: 0))
                path.addCurve(to: CGPoint(x: width / 2, y: height / 2), controlPoint1: CGPoint(x: xPosition, y: height / 3), controlPoint2: CGPoint(x: width / 2, y: height / 4))
                path.addCurve(to: CGPoint(x: xPosition, y: height), controlPoint1: CGPoint(x: width / 2, y: height * 3 / 4), controlPoint2: CGPoint(x: xPosition, y: height * 2 / 3))
                path.addLine(to: CGPoint(x: 0, y: height))
            } else {
                path.addLine(to: CGPoint(x: xPosition, y: 0))
                path.addCurve(to: CGPoint(x: width / 2, y: height / 2), controlPoint1: CGPoint(x: xPosition, y: height / 3), controlPoint2: CGPoint(x: width / 2, y: height / 4))
                path.addCurve(to: CGPoint(x: xPosition, y: height), controlPoint1: CGPoint(x: width / 2, y: height * 3 / 4), controlPoint2: CGPoint(x: xPosition, y: height * 2 / 3))
                path.addLine(to: CGPoint(x: 0, y: height))
            }
        }
        path.close()
        
        return path.cgPath
    }
}

extension SportViewController: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        bgLayer.removeAnimation(forKey: "path")
        bgLayer.path = getPath(offset: offset)
    }
}
