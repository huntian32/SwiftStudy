//
//  ViewController.swift
//  SwiftStudy1-2048
//
//  Created by huntian on 2018/4/16.
//  Copyright © 2018年 huntian. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func setupGame(_ sender: UIButton) {
        let game = NumbertailGameController (demension: 4, threshold: 2048)
        self.present(game, animated: true , completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.	
    }


}

