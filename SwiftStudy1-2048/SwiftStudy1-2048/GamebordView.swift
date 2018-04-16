//
//  GamebordView.swift
//  SwiftStudy1-2048
//
//  Created by huntian on 2018/4/16.
//  Copyright © 2018年 huntian. All rights reserved.
//

import Foundation

import UIKit
class GamebordView : UIView {
    var demension : Int //每行(列)区块个数
    var tileWidth : CGFloat  //每个小块的宽度
    var tilePadding : CGFloat  //每个小块间的间距
    //初始化，其中backgroundColor是游戏区块的背景色，foregroundColor是小块的颜色
    init(demension d : Int, titleWidth width : CGFloat, titlePadding padding : CGFloat, backgroundColor : UIColor, foregroundColor : UIColor ) {
        demension = d
        tileWidth = width
        tilePadding = padding
        let totalWidth = tilePadding + CGFloat(demension)*(tilePadding + tileWidth)
        super.init(frame : CGRect(x:0 , y:0 , width: totalWidth , height: totalWidth))
        self.backgroundColor = backgroundColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
