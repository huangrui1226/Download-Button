//
//  ViewController.swift
//  Animations
//
//  Created by 黄瑞 on 2017/8/9.
//  Copyright © 2017年 黄瑞. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var length: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        length = view.frame.size.width / 2

        downloadButton()
        loadingView()
    }
    
    func downloadButton() {
        
        let button = DownloadButton(frame: CGRect(x: 0, y: 0, width: length, height: length))
        button.center = CGPoint(x: view.center.x, y: view.center.y - length / 2 - 8)
        self.view.addSubview(button)
    }
    
    func loadingView() {
        
        let waveView = LoadingView(frame: CGRect(x: 0, y: 0, width: length, height: length))
        waveView.center = CGPoint(x: view.center.x, y: view.center.y + length / 2 + 8)
        view.addSubview(waveView)
    }
}

