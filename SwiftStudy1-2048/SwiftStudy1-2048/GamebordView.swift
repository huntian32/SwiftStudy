//
//  GamebordView.swift
//  SwiftStudy1-2048
//
//  Created by huntian on 2018/4/16.
//  Copyright © 2018年 huntian. All rights reserved.
//

import UIKit
class GamebordView : UIView {
    var demension : Int //每行(列)区块个数
    var tileWidth : CGFloat  //每个小块的宽度
    var tilePadding : CGFloat  //每个小块间的间距
    let provider = AppearanceProvider()
    var tiles : Dictionary<IndexPath , TileView>
    let tileExpandTime: TimeInterval = 0.18
    let tileContractTime: TimeInterval = 0.08
    let tilePopDelay: TimeInterval = 0.05
    let tilePopStartScale: CGFloat = 0.1
    let tilePopMaxScale: CGFloat = 1.1
    
    
    //初始化，其中backgroundColor是游戏区块的背景色，foregroundColor是小块的颜色
    init(demension d : Int, titleWidth width : CGFloat, titlePadding padding : CGFloat, backgroundColor : UIColor, foregroundColor : UIColor ) {
        demension = d
        tileWidth = width
        tilePadding = padding
        let totalWidth = tilePadding + CGFloat(demension)*(tilePadding + tileWidth)
        super.init(frame : CGRect(x:0 , y:0 , width: totalWidth , height: totalWidth))
        self.backgroundColor = backgroundColor
        }
    
    
    func setColor (backgroundColor bgcolor : UIColor, foregroundColor forecolor : UIColor){
        self.backgroundColor = bgcolor
        var xCursor = tilePadding
        var yCursor : CGFloat
        
        for _ in 0..<demension{
            yCursor = tilePadding
            for _ in 0..<demension {
                let tileFrame = UIView(frame : CGRect(x: xCursor, y: yCursor, width: tileWidth, height: tileWidth))
                tileFrame.backgroundColor = forecolor
                tileFrame.layer.cornerRadius = 8
                addSubview(tileFrame)
                yCursor += tilePadding + tileWidth
            }
            xCursor += tilePadding + tileWidth
        }
    }
    
    func insertTile(pos : (Int , Int) , value : Int) {
        assert(positionIsValied(position: pos))
        let (row , col) = pos
        //取出当前数字块的左上角坐标(相对于游戏区块)
        let x = tilePadding + CGFloat(row)*(tilePadding + tileWidth)
        let y = tilePadding + CGFloat(col)*(tilePadding + tileWidth)
        let tileView = TileView(position : CGPoint(x:x, y:y), width: tileWidth, value: value, delegate: provider)
        addSubview(tileView)
        bringSubview(toFront: tileView)
        
        tiles [IndexPath(Row : row , Section:  col)] = tileView
//        tiles[NSIndexPath(forRow : row , inSection:  col)] = tileView
        //这里就是一些动画效果，如果有兴趣可以研究下，不影响功能
//        UIView.animate(withDuration: tileExpandTime, delay: tilePopDelay, options: UIViewAnimationOptions.TransitionNone,
//                                   animations: {
//                                    tileView.layer.setAffineTransform(CGAffineTransform(scaleX: self.tilePopMaxScale, y: self.tilePopMaxScale))
//        },
//                                   completion: { finished in
//                                    UIView.animate(withDuration: self.tileContractTime, animations: { () -> Void in
//                                        tileView.layer.setAffineTransform(CGAffineTransformIdentity)
//                                    })
//        })
    }
    
    func positionIsValied(position : (Int , Int)) -> Bool{
        let (x , y) = position
        return x >= 0 && x < demension && y >= 0 && y < demension
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
