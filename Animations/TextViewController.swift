//
//  TextViewController.swift
//  Animations
//
//  Created by 黄瑞 on 2017/8/10.
//  Copyright © 2017年 黄瑞. All rights reserved.
//

import UIKit
import CoreText

class TextViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Core text version is \(CTGetCoreTextVersion())")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
