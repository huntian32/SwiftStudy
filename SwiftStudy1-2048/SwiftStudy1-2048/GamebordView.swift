//
//  GamebordView.swift
//  SwiftStudy1-2048
//
//  Created by huntian on 2018/4/16.
//  Copyright © 2018年 huntian. All rights reserved.
//

import UIKit
class GamebordView : UIView {
    var dimension : Int //每行(列)区块个数
    var tileWidth : CGFloat  //每个小块的宽度
    var tilePadding : CGFloat  //每个小块间的间距
    let provider = AppearanceProvider()
    var tiles : Dictionary<NSIndexPath , TileView>
    let tileExpandTime: TimeInterval = 0.18
    let tileContractTime: TimeInterval = 0.08
    let tilePopDelay: TimeInterval = 0.05
    let tilePopStartScale: CGFloat = 0.1
    let tilePopMaxScale: CGFloat = 1.1
    let perSquareSlideDuration: TimeInterval = 0.08
    
    
    
    //初始化，其中backgroundColor是游戏区块的背景色，foregroundColor是小块的颜色
    init(dimension d : Int, titleWidth width : CGFloat, titlePadding padding : CGFloat, backgroundColor : UIColor, foregroundColor : UIColor ) {
        
        self.tiles = Dictionary<NSIndexPath, TileView>()
        
        dimension = d
        tileWidth = width
        tilePadding = padding
        let totalWidth = tilePadding + CGFloat(dimension)*(tilePadding + tileWidth)
        super.init(frame: CGRect(x: 0, y: 0, width: totalWidth, height: totalWidth))
        self.backgroundColor = backgroundColor
        }
    
    
    func setColor (backgroundColor bgcolor : UIColor, foregroundColor forecolor : UIColor){
        self.backgroundColor = bgcolor
        var xCursor = tilePadding
        var yCursor : CGFloat
        
        for _ in 0..<dimension{
            yCursor = tilePadding
            for _ in 0..<dimension {
                let tileFrame = UIView(frame : CGRect(x: xCursor, y: yCursor, width: tileWidth, height: tileWidth))
                tileFrame.backgroundColor = forecolor
                tileFrame.layer.cornerRadius = 8
                addSubview(tileFrame)
                yCursor += tilePadding + tileWidth
            }
            xCursor += tilePadding + tileWidth
        }
    }
    
    func insertTile(position pos : (Int , Int) , value : Int) {
        assert(positionIsValied(position: pos))
        let (row , col) = pos
        //取出当前数字块的左上角坐标(相对于游戏区块)
        let x = tilePadding + CGFloat(row)*(tilePadding + tileWidth)
        let y = tilePadding + CGFloat(col)*(tilePadding + tileWidth)
        let tileView = TileView(position : CGPoint(x:x, y:y), width: tileWidth, value: value, delegate: provider)
        addSubview(tileView)
        bringSubview(toFront: tileView)
        
        //tiles [IndexPath(Row : row , Section:  col)] = tileView
//        tiles[NSIndexPath(forRow : row , inSection:  col)] = tileView
        tiles[NSIndexPath(row : row , section:  col)] = tileView
        
        //这里就是一些动画效果，如果有兴趣可以研究下，不影响功能
        UIView.animate(withDuration: tileExpandTime, delay: tilePopDelay, options: UIViewAnimationOptions.transitionFlipFromTop,
                                   animations: {
                                    tileView.layer.setAffineTransform(CGAffineTransform(scaleX: self.tilePopMaxScale, y: self.tilePopMaxScale))
        },
                                   completion: { finished in
                                    UIView.animate(withDuration: self.tileContractTime, animations: { () -> Void in
                                        tileView.layer.setAffineTransform(CGAffineTransform.identity)
                                    })
        })
    }
    
    //从from位置移动一个块到to位置，并赋予新的值value
    func moveOneTile(from : (Int , Int)  , to : (Int , Int) , value : Int) {
        let (fx , fy) = from
        let (tx , ty) = to
        let fromKey = NSIndexPath(row: fx , section: fy)
        let toKey = NSIndexPath(row: tx, section: ty)
        //取出from位置和to位置的数字块
        guard let tile = tiles[fromKey] else{
            assert(false, "not exists tile")
        }
        let endTile = tiles[toKey]
        //将from位置的数字块的位置定到to位置
        var changeFrame = tile.frame
        changeFrame.origin.x = tilePadding + CGFloat(tx)*(tilePadding + tileWidth)
        changeFrame.origin.y = tilePadding + CGFloat(ty)*(tilePadding + tileWidth)
        
        tiles.removeValue(forKey: fromKey)
        tiles[toKey] = tile
        
        // 动画以及给新位置的数字块赋值
        let shouldPop = endTile != nil
        
        UIView.animate(withDuration: perSquareSlideDuration,
                                   delay: 0.0,
                                   options: UIViewAnimationOptions.beginFromCurrentState,
                                   animations: {
                                    tile.frame = changeFrame
        },
                                   completion: { (finished: Bool) -> Void in
                                    //对新位置的数字块赋值
                                    tile.value = value
                                    endTile?.removeFromSuperview()
                                    if !shouldPop || !finished {
                                        return
                                    }
                                    tile.layer.setAffineTransform(CGAffineTransform(scaleX: self.tilePopStartScale, y: self.tilePopStartScale))
                                    UIView.animate(withDuration: self.tileExpandTime,
                                                               animations: {
                                                                tile.layer.setAffineTransform(CGAffineTransform(scaleX: self.tilePopMaxScale, y: self.tilePopMaxScale))
                                    },
                                                               completion: { finished in
                                                                UIView.animate(withDuration: self.tileContractTime) {
                                                                    tile.layer.setAffineTransform(CGAffineTransform.identity)
                                                                }
                                    })
        })
    }
    //将from里两个位置的数字块移动到to位置，并赋予新的值，原理同上
    func moveTwoTiles(from: ((Int, Int), (Int, Int)), to: (Int, Int), value: Int) {
        assert(positionIsValied(position: from.0) && positionIsValied(position: from.1) && positionIsValied(position: to))
        let (fromRowA, fromColA) = from.0
        let (fromRowB, fromColB) = from.1
        let (toRow, toCol) = to
        let fromKeyA = NSIndexPath(row: fromRowA, section: fromColA)
        let fromKeyB = NSIndexPath(row: fromRowB, section: fromColB)
        let toKey = NSIndexPath(row: toRow, section: toCol)
        
        guard let tileA = tiles[fromKeyA] else {
            assert(false, "placeholder error")
        }
        guard let tileB = tiles[fromKeyB] else {
            assert(false, "placeholder error")
        }
        
        var finalFrame = tileA.frame
        finalFrame.origin.x = tilePadding + CGFloat(toRow)*(tileWidth + tilePadding)
        finalFrame.origin.y = tilePadding + CGFloat(toCol)*(tileWidth + tilePadding)
        
        let oldTile = tiles[toKey]
        oldTile?.removeFromSuperview()
        tiles.removeValue(forKey: fromKeyA)
        tiles.removeValue(forKey: fromKeyB)
        tiles[toKey] = tileA
        
        
        UIView.animate(withDuration: perSquareSlideDuration,
                       delay: 0.0,
                       options: UIViewAnimationOptions.beginFromCurrentState,
                       animations: {
                        tileA.frame = finalFrame
                        tileB.frame = finalFrame
        }, completion: { finished in
            //赋值
            tileA.value = value
            tileB.removeFromSuperview()
            if !finished {
                return
            }
            tileA.layer.setAffineTransform(CGAffineTransform(scaleX: self.tilePopStartScale, y: self.tilePopStartScale))
            UIView.animate(withDuration: self.tileExpandTime,
                                       animations: {
                                        tileA.layer.setAffineTransform(CGAffineTransform(scaleX: self.tilePopMaxScale, y: self.tilePopMaxScale))
            },
                                       completion: { finished in
                                        UIView.animate(withDuration: self.tileContractTime) {
                                            tileA.layer.setAffineTransform(CGAffineTransform.identity)
                                        }
            })
        })
        

    }
    
    func positionIsValied(position : (Int , Int)) -> Bool{
        let (x , y) = position
        return x >= 0 && x < dimension && y >= 0 && y < dimension
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
