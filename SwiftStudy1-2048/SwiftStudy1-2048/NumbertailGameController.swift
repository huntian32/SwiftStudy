//
//  NumbertailGameController.swift
//  SwiftStudy1-2048
//
//  Created by huntian on 2018/4/16.
//  Copyright © 2018年 huntian. All rights reserved.
//

import UIKit


class NumbertailGameController : UIViewController {
    var demension : Int  //2048游戏中每行每列含有多少个块
    var threshold : Int  //最高分数，判断输赢时使用，
    let boardWidth: CGFloat = 260.0  //游戏区域的长度和高度
    let thinPadding: CGFloat = 3.0  //游戏区里面小块间的间距
    let viewPadding: CGFloat = 10.0  //计分板和游戏区块的间距
    let verticalViewOffset: CGFloat = 0.0  //一个初始化属性，后面会有地方用到
    var bord : GamebordView?
    
    init(demension d : Int , threshold t : Int) {
        demension = d < 2 ? 2 : d
        threshold = t < 8 ? 8 : t
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = UIColor(red : 0xE6/255, green : 0xE2/255, blue : 0xD4/255, alpha : 1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            var h:CGFloat = 0.0
            for view in views {
                h = h + view.bounds.size.height
            }
            let totalViewHeigth = CGFloat(views.count - 1)*viewPadding + h
//            views.map({$0.bounds.size.height}).reduce(verticalViewOffset , combine: {$0 + $1})
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
            backgroundColor:UIColor(red : 0x90/255, green : 0x8D/255, blue : 0x80/255, alpha : 1),
            foregroundColor:UIColor(red : 0xF9/255, green : 0xF9/255, blue : 0xE3/255, alpha : 0.5)
        )
        
        //初始化一个ScoreView
        let scoreView = ScoreView(
            backgroundColor:  UIColor(red : 0xA2/255, green : 0x94/255, blue : 0x5E/255, alpha : 1),
            textColor: UIColor(red : 0xF3/255, green : 0xF1/255, blue : 0x1A/255, alpha : 0.5),
            font: UIFont(name: "HelveticaNeue-Bold", size: 16.0) ?? UIFont.systemFont(ofSize: 16.0)
        )
        
        //现在面板中所有的视图对象，目前只有游戏区块，后续加入计分板
        let views = [scoreView , gamebord]
        //设置游戏区块在整个面板中的的绝对位置，即左上角第一个点
        var f = gamebord.frame
        f.origin.x = xposition2Center(view: gamebord)
        f.origin.y = yposition2Center(order: 0, views: views)
        let backgroundColor = UIColor(red : 0x90/255, green : 0x8D/255, blue : 0x80/255, alpha : 1),
        foregroundColor = UIColor(red : 0xF9/255, green : 0xF9/255, blue : 0xE3/255, alpha : 0.5)
        gamebord.setColor(backgroundColor: backgroundColor, foregroundColor: foregroundColor)
        gamebord.frame = f
        
        //定位记分板在主面板中左上角的绝对位置
        var f1 = scoreView.frame
        f1.origin.x = xposition2Center(view: scoreView)
        f1.origin.y = yposition2Center(order: 0, views: views) - 50
        scoreView.frame = f1
        //调用其自身方法来初始化一个分数
        scoreView.scoreChanged(newScore: 19870606)
         //将游戏对象加入当前面板中
        view.addSubview(gamebord)
        view.addSubview(scoreView)

        gamebord.insertTile(pos: (3,1) , value : 2)
        gamebord.insertTile(pos: (1,3) , value : 2)
    }
    
    func insertTile(pos : (Int , Int) , value : Int){
        assert(bord != nil)
        let b = bord!
        b.insertTile(pos: pos, value: value)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



