//
//  TestViewController06.swift
//  MicrosoftDemo
//
//  Created by Wicrenet_Jason on 2018/3/13.
//  Copyright © 2018年 Wicrenet_Jason. All rights reserved.
//

import UIKit

class TestViewController06: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func popAction(_ sender: UIButton) {
        self.popToRootVC()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
