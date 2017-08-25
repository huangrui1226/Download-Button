//
//  RuningMan.swift
//  Animations
//
//  Created by 黄瑞 on 2017/8/18.
//  Copyright © 2017年 黄瑞. All rights reserved.
//

import UIKit

class RuningMan: UIView {
    
    let shapeLayer = CAShapeLayer()
    var currentFrame: Int = 0                   // 当前帧
    
    var width: CGFloat { return self.frame.size.width }
    var height: CGFloat { return self.frame.size.height }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        CADisplayLink(target: self, selector: #selector(update)).add(to: .main, forMode: .commonModes)
        
        layer.addSublayer(shapeLayer)
    }
    
    // 更新动画
    @objc func update() {
        currentFrame += 1
        if currentFrame > 60 {
            currentFrame = 0
        }
        shapeLayer.fillColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.path = getPath(frame: currentFrame)
    }

    // 绘制跑动的小人
    func getPath(frame: Int) -> CGPath {
        let path = UIBezierPath()
        
        // head
        path.addArc(withCenter: CGPoint(x: width / 2, y: 20), radius: 10, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        path.fill()
        
        return path.cgPath
    }
}
