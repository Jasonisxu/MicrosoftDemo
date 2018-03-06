//
//  ViewController.swift
//  MicrosoftDemo
//
//  Created by Wicrenet_Jason on 2018/3/6.
//  Copyright © 2018年 Wicrenet_Jason. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        self.isNavBarHidden = true
    }
    
    @IBAction func testAction(_ sender: UIButton) {
        self.pushVC(TestViewController())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

