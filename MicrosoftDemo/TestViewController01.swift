//
//  TestViewController01.swift
//  MicrosoftDemo
//
//  Created by Wicrenet_Jason on 2018/3/13.
//  Copyright © 2018年 Wicrenet_Jason. All rights reserved.
//

import UIKit

class TestViewController01: UIViewController {

    @IBOutlet weak var bgImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        bgImageView.addTapGesture(action: { [weak self] (tap) in
            if let strongSelf = self{
                strongSelf.navigationController?.popViewController(animated: false)
            }
        })
        
    }
    
    @IBAction func popAction(_ sender: UIButton) {
        self.popVC()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
