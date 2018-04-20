//
//  NumbertailGameController.swift
//  SwiftStudy1-2048
//
//  Created by huntian on 2018/4/16.
//  Copyright © 2018年 huntian. All rights reserved.
//

import UIKit
protocol GameModelProtocol : class {
    func changeScore(score : Int)
    func insertTile(position : (Int , Int), value : Int)
    func moveOneTile(from: (Int, Int), to: (Int, Int), value: Int)
    func moveTwoTiles(from: ((Int, Int), (Int, Int)), to: (Int, Int), value: Int)
}

class NumbertailGameController : UIViewController , GameModelProtocol{
    var dimension : Int  //2048游戏中每行每列含有多少个块
    var threshold : Int  //最高分数，判断输赢时使用，
    let boardWidth: CGFloat = 260.0  //游戏区域的长度和高度
    let thinPadding: CGFloat = 3.0  //游戏区里面小块间的间距
    let viewPadding: CGFloat = 10.0  //计分板和游戏区块的间距
    let verticalViewOffset: CGFloat = 0.0  //一个初始化属性，后面会有地方用到
    var bord : GamebordView?
    var scoreV : ScoreView?
    var gameModle : GameModle?
    var changeNumber : Dictionary<Int, String>
    
    init(dimension d : Int , threshold t : Int , changeNumber : Dictionary<Int, String>) {
        dimension = d < 2 ? 2 : d
        threshold = t < 8 ? 8 : t
        self.changeNumber = changeNumber
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = UIColor(red : 0xE6/255, green : 0xE2/255, blue : 0xD4/255, alpha : 1)
        
    }
    
    //注册监听器，监听当前视图里的手指滑动操作，上下左右分别对应下面的四个方法
    func setupSwipeConttoller() {
        let upSwipe = UISwipeGestureRecognizer(target: self , action: #selector(NumbertailGameController.upCommand(r:)))
        upSwipe.numberOfTouchesRequired = 1
        upSwipe.direction = UISwipeGestureRecognizerDirection.up
        view.addGestureRecognizer(upSwipe)
        
        let downSwipe = UISwipeGestureRecognizer(target: self , action: #selector(NumbertailGameController.downCommand(r:)))
        downSwipe.numberOfTouchesRequired = 1
        downSwipe.direction = UISwipeGestureRecognizerDirection.down
        view.addGestureRecognizer(downSwipe)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self , action: #selector(NumbertailGameController.leftCommand(r:)))
        leftSwipe.numberOfTouchesRequired = 1
        leftSwipe.direction = UISwipeGestureRecognizerDirection.left
        view.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self , action: #selector(NumbertailGameController.rightCommand(r:)))
        rightSwipe.numberOfTouchesRequired = 1
        rightSwipe.direction = UISwipeGestureRecognizerDirection.right
        view.addGestureRecognizer(rightSwipe)
    }
    //向上滑动的方法，调用queenMove，传入MoveDirection.UP
    @objc func upCommand(r : UIGestureRecognizer) {
        let m = gameModle!
        m.queenMove(direction: MoveDirection.UP , completion: { (changed : Bool) -> () in
            if  changed {
                self.followUp()
            }
        })
    }
    //向下滑动的方法，调用queenMove，传入MoveDirection.DOWN
    @objc func downCommand(r : UIGestureRecognizer) {
        let m = gameModle!
        m.queenMove(direction: MoveDirection.DOWN , completion: { (changed : Bool) -> () in
            if  changed {
                self.followUp()
            }
        })
    }
    //向左滑动的方法，调用queenMove，传入MoveDirection.LEFT
    @objc func leftCommand(r : UIGestureRecognizer) {
        let m = gameModle!
        m.queenMove(direction: MoveDirection.LEFT , completion: { (changed : Bool) -> () in
            if  changed {
                self.followUp()
            }
        })
    }
    //向右滑动的方法，调用queenMove，传入MoveDirection.RIGHT
    @objc func rightCommand(r : UIGestureRecognizer) {
        let m = gameModle!
        m.queenMove(direction: MoveDirection.RIGHT , completion: { (changed : Bool) -> () in
            if  changed {
                self.followUp()
            }
        })
    }
    //移动之后需要判断用户的输赢情况，如果赢了则弹框提示，给一个重玩和取消按钮
    func followUp() {
        assert(gameModle != nil)
        let m = gameModle!
        let (userWon, _) = m.userHasWon()
        if userWon {
            let winAlertView = UIAlertController(title: "結果", message: "你贏了", preferredStyle: UIAlertControllerStyle.alert)
            let resetAction = UIAlertAction(title: "重置", style: UIAlertActionStyle.default, handler: {(u : UIAlertAction) -> () in
                self.reset()
            })
            winAlertView.addAction(resetAction)
            let cancleAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.default, handler: nil)
            winAlertView.addAction(cancleAction)
            self.present(winAlertView, animated: true, completion: nil)
            return
        }
        //如果没有赢则需要插入一个新的数字块
        let randomVal = Int(arc4random_uniform(10))
        m.insertRandomPositoinTile(value: randomVal == 1 ? 4 : 2)
        //插入数字块后判断是否输了，输了则弹框提示
        if m.userHasLost() {
            NSLog("You lost...")
            let lostAlertView = UIAlertController(title: "結果", message: "你輸了", preferredStyle: UIAlertControllerStyle.alert)
            let resetAction = UIAlertAction(title: "重置", style: UIAlertActionStyle.default, handler: {(u : UIAlertAction) -> () in
                self.reset()
            })
            lostAlertView.addAction(resetAction)
            let cancleAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.default, handler: nil)
            lostAlertView.addAction(cancleAction)
            self.present(lostAlertView, animated: true, completion: nil)
        }
    }
    
    func reset() {
        assert(bord != nil && gameModle != nil)
        //let b = bord!
        let m = gameModle!
       // b.reset()
       // m.reset()
        m.insertRandomPositoinTile(value: 2)
        m.insertRandomPositoinTile(value: 2)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameModle = GameModle(dimension: dimension, threshold: threshold, delegate: self)
        setupSwipeConttoller()
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
        let width = (boardWidth - thinPadding*CGFloat(dimension + 1))/CGFloat(dimension)
        //初始化一个游戏区块对象
            bord = GamebordView(
            dimension : dimension,
            titleWidth: width,
            titlePadding: thinPadding,
            backgroundColor : UIColor(red : 0x90/255, green : 0x8D/255, blue : 0x80/255, alpha : 1),
            foregroundColor : UIColor(red : 0xF9/255, green : 0xF9/255, blue : 0xE3/255, alpha : 0.5),
            changeNumber : changeNumber
        )
        
        //初始化一个ScoreView
        let scoreView = ScoreView(
            backgroundColor:  UIColor(red : 0xA2/255, green : 0x94/255, blue : 0x5E/255, alpha : 1),
            textColor: UIColor(red : 0xF3/255, green : 0xF1/255, blue : 0x1A/255, alpha : 0.5),
            font: UIFont(name: "HelveticaNeue-Bold", size: 16.0) ?? UIFont.systemFont(ofSize: 16.0)
        )
        
        scoreV = scoreView
        //现在面板中所有的视图对象，目前只有游戏区块，后续加入计分板
        let views = [scoreView , bord]
        //设置游戏区块在整个面板中的的绝对位置，即左上角第一个点
        var f = bord?.frame
        f?.origin.x = xposition2Center(view: bord!)
        f?.origin.y = yposition2Center(order: 0, views: views as! [UIView])
        let backgroundColor = UIColor(red : 0x90/255, green : 0x8D/255, blue : 0x80/255, alpha : 1),
        foregroundColor = UIColor(red : 0xF9/255, green : 0xF9/255, blue : 0xE3/255, alpha : 0.5)
        bord?.setColor(backgroundColor: backgroundColor, foregroundColor: foregroundColor)
        bord?.frame = f!
        
//        bord = gamebord
        //定位记分板在主面板中左上角的绝对位置
        var f1 = scoreView.frame
        f1.origin.x = xposition2Center(view: scoreView)
        f1.origin.y = yposition2Center(order: 0, views: views as! [UIView]) - 50
        scoreView.frame = f1
        //调用其自身方法来初始化一个分数
        scoreView.scoreChanged(newScore: 19870606)
         //将游戏对象加入当前面板中
        view.addSubview(bord!)
        view.addSubview(scoreView)

//        bord?.insertTile(position: (3,1) , value : 2)
//        bord?.insertTile(position: (1,3) , value : 2)
        
        scoreView.scoreChanged(newScore: 0)
        
        assert(gameModle != nil)
        let modle = gameModle!
        modle.insertRandomPositoinTile(value: 2)
        modle.insertRandomPositoinTile(value: 2)
        modle.insertRandomPositoinTile(value: 2)
    }
    func changeScore(score : Int){
        assert(scoreV != nil)
        let s =  scoreV!
        s.scoreChanged(newScore: score)
    }
    
    func insertTile(position pos : (Int , Int) , value : Int){
        assert(bord != nil)
        let b = bord!
        b.insertTile(position: pos, value: value)
    }
    
    func moveOneTile(from: (Int, Int), to: (Int, Int), value: Int) {
        assert(bord != nil)
        let b = bord!
        b.moveOneTile(from: from, to: to, value: value)
    }
    
    func moveTwoTiles(from: ((Int, Int), (Int, Int)), to: (Int, Int), value: Int) {
        assert(bord != nil)
        let b = bord!
        b.moveTwoTiles(from: from, to: to, value: value)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



