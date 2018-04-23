//
//  ViewController.swift
//  SwiftStudy1-2048
//
//  Created by huntian on 2018/4/16.
//  Copyright © 2018年 huntian. All rights reserved.
//

import UIKit

class ViewController: UIViewController /*,UIPickerViewDelegate, UIPickerViewDataSource*/ {
//    let pickerView = UIPickerView()
//    //设置选择框的列数
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 2
//    }
//    //设置选择框的行数
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return 3
//    }
    var selectDimension = 4
    var selectThreshold = 2048
    var changeNumber : Dictionary<Int, String> = [2:"2",4:"4",8:"8",16:"16",32:"32",64:"64",128:"128",256:"256",512:"512",1024:"1024",2048:"2048"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        let defaultTitle = "请选择方块显示类别"
        let choices = ["数字版", "军衔版", "朝代版", "官职版", "职务版"]
        let rect = CGRect(x: 50, y: 100, width: self.view.frame.width - 100, height: 50)
        let dropBoxView = TGDropBoxView(parentVC: self, title: defaultTitle, items: choices, frame: rect)
        dropBoxView.isHightWhenShowList = true
        dropBoxView.willShowOrHideBoxListHandler = { (isShow) in
            if isShow { NSLog("will show choices") }
            else { NSLog("will hide choices") }
        }
        dropBoxView.didShowOrHideBoxListHandler = { (isShow) in
            if isShow { NSLog("did show choices") }
            else { NSLog("did hide choices") }
        }
            dropBoxView.didSelectBoxItemHandler = { (row) in
                switch row {
                case 0:
                    self.changeNumber = [2:"2",4:"4",8:"8",16:"16",32:"32",64:"64",128:"128",256:"256",512:"512",1024:"1024",2048:"2048"]
                    self.selectDimension = 4
                    self.selectThreshold = 2048
                case 1:
                    self.changeNumber = [2:"少尉",4:"中尉",8:"上尉",16:"少校",32:"中校",64:"上校",128:"大校",256:"少将",512:"中将",1024:"上将",2048:"大将",4096:"元帅"]
                    self.selectThreshold = 4096
                case 2:
                    self.changeNumber = [2:"秦",4:"汉",8:"三国",16:"晋",32:"南北朝",64:"隋",128:"唐",256:"宋",512:"元",1024:"明",2048:"清"]
                case 3:
                    self.changeNumber = [2:"副科",4:"正科",8:"副处",16:"正处",32:"副局",64:"正局",128:"副部",256:"正部",512:"副国",1024:"正国",2048:"总书记"]
                case 4:
                    self.changeNumber = [2:"村民",4:"村长",8:"副镇长",16:"镇长",32:"副县长",64:"县长",128:"副市长",256:"市长",512:"副省长",1024:"省长",2048:"副总理", 4096:"总理"]
                    self.selectThreshold = 4096
                default:
                    self.changeNumber = [2:"2",4:"4",8:"8",16:"16",32:"32",64:"64",128:"128",256:"256",512:"512",1024:"1024",2048:"2048"]
                    self.selectThreshold = 2048
                }
            }
            self.view.addSubview(dropBoxView)
        
        //第二个选择框：选择难度
        let defaultTitle1 = "请选择难度"
        let choices1 = ["极简单", "简单", "正常"]
        let rect1 = CGRect(x: 50, y: 180, width: self.view.frame.width - 100, height: 50)
        let dropBoxView1 = TGDropBoxView(parentVC: self, title: defaultTitle1, items: choices1, frame: rect1)
        dropBoxView1.isHightWhenShowList = true
        dropBoxView1.willShowOrHideBoxListHandler = { (isShow) in
            if isShow { NSLog("will show choices") }
            else { NSLog("will hide choices") }
        }
        dropBoxView1.didShowOrHideBoxListHandler = { (isShow) in
            if isShow { NSLog("did show choices") }
            else { NSLog("did hide choices") }
        }
        dropBoxView1.didSelectBoxItemHandler = { (row) in
            switch row {
            case 0:
                self.selectDimension = 6
            case 1:
                self.selectDimension = 5
            case 2:
                self.selectDimension = 4
            default:
                self.selectDimension = 4
            }
        }
        self.view.addSubview(dropBoxView1)
        //修改开始游戏的样式
        setupGameBtn.backgroundColor = gameButtonBackgroundColor
        setupGameBtn.setTitleColor(gameButtonTitleColor, for: .normal)
        setupGameBtn.titleLabel?.font = gameButtonFont
        
        // Do any additional setup after loading the view, typically from a nib.
      
    }
 
    @IBOutlet weak var setupGameBtn: UIButton!
    
    @IBAction func setupGame(_ sender: UIButton) {
        let game = NumbertailGameController.init(dimension: selectDimension, threshold: selectThreshold,changeNumber:changeNumber)
        
        self.present(game, animated: true , completion: nil)
    }
    

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.	
    }


}

