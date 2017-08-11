//
//  ViewController.swift
//  Animations
//
//  Created by 黄瑞 on 2017/8/9.
//  Copyright © 2017年 黄瑞. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var waveView: LoadingView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        downloadButton()
        loadingView()
    }

    @objc func sliderValueChange(_ sender: UISlider) {
        waveView?.progress = CGFloat(sender.value)
    }
    
    func downloadButton() {
        let button = DownloadButton(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        button.center = self.view.center
        self.view.addSubview(button)
    }
    
    func loadingView() {
        
        let slider = UISlider(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        slider.minimumValue = 0.0
        slider.maximumValue = 1.0
        slider.value = 0.5
        slider.addTarget(self, action: #selector(sliderValueChange(_:)), for: .valueChanged)
        slider.center = CGPoint(x: view.center.x, y: view.center.y + 300)
        view.addSubview(slider)

        waveView = LoadingView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        waveView?.center = view.center
        view.addSubview(waveView!)
    }
}

