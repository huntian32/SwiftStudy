//
//  TileView.swift
//  SwiftStudy1-2048
//
//  Created by huntian on 2018/4/17.
//  Copyright © 2018年 huntian. All rights reserved.
//

import UIKit

class TileView : UIView{
    //改变数字的显示（如汉字）
    var changeNumber : Dictionary <Int , String>
    //数字块中的值
    var value : Int = 0 {
        didSet{
            backgroundColor = delegate.tileColor(value: value)
            lable.textColor = delegate.numberColor(value: value)
            lable.text = changeNumber[value]//"\(value)"
        }
    }
    //提供颜色选择
    unowned let delegate : AppearanceProviderProtocol
    //一个数字块也就是一个lable
    var lable : UILabel
    
    init(position : CGPoint, width : CGFloat, value : Int, delegate d: AppearanceProviderProtocol, changeNumber :Dictionary<Int,String>){
        self.changeNumber = changeNumber
        delegate = d
        lable = UILabel(frame : CGRect(x:0 , y:0 , width:width , height:width))
        lable.textAlignment = NSTextAlignment.center
        lable.minimumScaleFactor = 0.5
        lable.font = UIFont(name: "HelveticaNeue-Bold", size: 15) ?? UIFont.systemFont(ofSize: 15)
        super.init(frame: CGRect(x:position.x, y:position.y, width:width , height:width))
        addSubview(lable)
        lable.layer.cornerRadius = 6
        self.value = value
        backgroundColor = delegate.tileColor(value: value)
        lable.textColor = delegate.numberColor(value: value)
        
        lable.text = changeNumber[value]//"\(value)"
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
