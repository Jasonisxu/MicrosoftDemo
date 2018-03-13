//
//  TestViewController02.swift
//  MicrosoftDemo
//
//  Created by Wicrenet_Jason on 2018/3/13.
//  Copyright © 2018年 Wicrenet_Jason. All rights reserved.
//

import UIKit

class TestViewController02: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func popAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
        
}
