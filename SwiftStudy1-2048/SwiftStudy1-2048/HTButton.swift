//
//  HTButton.swift
//  SwiftStudy1-2048
//
//  Created by huntian on 2018/4/20.
//  Copyright © 2018年 huntian. All rights reserved.
//

import UIKit


extension UIButton
{
    class func quickCreateButton(title:String, frame: CGRect) -> UIButton {
        let btn: UIButton = UIButton.init()
        btn.frame = frame
        btn.backgroundColor = gameButtonBackgroundColor
        btn.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0) ?? UIFont.systemFont(ofSize: 16.0)
        btn.setTitleColor(UIColor(red : 0xF3/255, green : 0xF1/255, blue : 0x1A/255, alpha : 0.5), for: .normal)
        btn.setTitle(title, for: .normal)
        return btn
    }
}

