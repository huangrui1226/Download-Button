//
//  ViewController.swift
//  DownloadButton
//
//  Created by 黄瑞 on 2017/8/9.
//  Copyright © 2017年 黄瑞. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = DownloadButton(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        button.center = self.view.center
        self.view.addSubview(button)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

