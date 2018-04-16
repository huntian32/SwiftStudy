//
//  NumbertailGameController.swift
//  SwiftStudy1-2048
//
//  Created by huntian on 2018/4/16.
//  Copyright © 2018年 huntian. All rights reserved.
//

import Foundation
import UIKit

class NumbertailGameController : UIViewController {
    var demension : Int  //2048游戏中每行每列含有多少个块
    var threshold : Int  //最高分数，判断输赢时使用，
    let boardWidth: CGFloat = 260.0  //游戏区域的长度和高度
    let thinPadding: CGFloat = 3.0  //游戏区里面小块间的间距
    let viewPadding: CGFloat = 10.0  //计分板和游戏区块的间距
    let verticalViewOffset: CGFloat = 0.0  //一个初始化属性，后面会有地方用到
    init(demension d : Int , threshold t : Int) {
        demension = d < 2 ? 2 : d
        threshold = t < 8 ? 8 : t
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = UIColor(red : 0xE6/255, green : 0xE2/255, blue : 0xD4/255, alpha : 1)
    }
    
      override func viewDidLoad() {
        self.viewDidLoad()
        setupGame()
    }
    
    func setupGame(){
        let viewWidth = view.bounds.size.width
        let viewHeight = view.bounds.size.height
        //获取游戏区域左上角那个点的x坐标
        func xposition2Center(view v : UIView) -> CGFloat{
            let vWidth = v.bounds.size.width
            return 0.5*(viewWidth - vWidth)
            
        }
        //获取游戏区域左上角那个点的y坐标 (应为：当前面板总高度减去所有视图的总高度除以2然后在加上在游戏区块之前的视图的总高度，就是游戏区域的y坐标值)
        func yposition2Center(order : Int , views : [UIView]) -> CGFloat {
            assert(views.count > 0)
            let totalViewHeigth = CGFloat(views.count - 1)*viewPadding +
                views.map({$0.bounds.size.height}).reduce ( verticalViewOffset , combine: {$0 + $1})
            let firstY = 0.5*(viewHeight - totalViewHeigth)
            
            var acc : CGFloat = 0
            for i in 0..<order{
                acc += viewPadding + views[i].bounds.size.height
            }
            return acc + firstY
        }
        //获取具体每一个区块的边长，即：(游戏区块长度-间隙总和)/块数
        let width = (boardWidth - thinPadding*CGFloat(demension + 1))/CGFloat(demension)
        //初始化一个游戏区块对象
        let gamebord = GamebordView(
            demension : demension,
            titleWidth: width,
            titlePadding: thinPadding,
            backgroundColor:  UIColor(red : 0x90/255, green : 0x8D/255, blue : 0x80/255, alpha : 1),
            foregroundColor:UIColor(red : 0xF9/255, green : 0xF9/255, blue : 0xE3/255, alpha : 0.5)
        )
        //现在面板中所有的视图对象，目前只有游戏区块，后续加入计分板
        let views = [gamebord]
        //设置游戏区块在整个面板中的的绝对位置，即左上角第一个点
        var f = gamebord.frame
        f.origin.x = xposition2Center(view: gamebord)
        f.origin.y = yposition2Center(order: 0, views: views)
        gamebord.frame = f
        //将游戏对象加入当前面板中
        view.addSubview(gamebord)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



