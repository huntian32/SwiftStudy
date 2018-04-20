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
    var changeNumber : Dictionary<Int, String> =  [2:"2",4:"4",8:"8",16:"16",32:"32",64:"64",128:"128",256:"256",512:"512",1024:"1024",2048:"2048"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        let defaultTitle = "请选择方块显示类别"
        let choices = ["数字版", "军衔版", "朝代版", "官职版"]
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
                case 1:
                    self.changeNumber = [2:"少尉",4:"中尉",8:"上尉",16:"少校",32:"中校",64:"上校",128:"少将",256:"中将",512:"上将",1024:"大将",2048:"元帅"]
                case 2:
                    self.changeNumber = [2:"秦",4:"汉",8:"三国",16:"晋",32:"南北朝",64:"隋",128:"唐",256:"宋",512:"元",1024:"明",2048:"清"]
                case 3:
                    self.changeNumber = [2:"副科",4:"正科",8:"副处",16:"正处",32:"副局",64:"正局",128:"副部",256:"正部",512:"副国",1024:"正国",2048:"总书记"]
                default:
                    self.changeNumber = [2:"2",4:"4",8:"8",16:"16",32:"32",64:"64",128:"128",256:"256",512:"512",1024:"1024",2048:"2048"]
                }
            }
            self.view.addSubview(dropBoxView)
        // Do any additional setup after loading the view, typically from a nib.
      
    }
    
//    //设置选择框各选项的内容，继承于UIPickerViewDelegate协议
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int,
//                    forComponent component: Int) -> String? {
//        let pickerViewArray : Array<String> = ["军衔","普通","猪宝宝"]
//        let pickerViewArray2 : Array<String> = ["简单","正常"]
//        return String(pickerViewArray[row])+"-"+String(pickerViewArray2[component])
//    }
//
//    //触摸按钮时，获得被选中的索引
//    @objc func getPickerViewValue(){
//        let message = String(pickerView.selectedRow(inComponent: 0)) + "-"
//            + String(pickerView.selectedRow(inComponent: 1)) //+ "-"
//            //+ String(pickerView.selectedRow(inComponent: 2))
//        let alertController = UIAlertController(title: "被选中的索引为",
//                                                message: message, preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//        alertController.addAction(okAction)
//        self.present(alertController, animated: true, completion: nil)
//    }

    
    
    @IBAction func setupGame(_ sender: UIButton) {
      
        let game = NumbertailGameController.init(dimension: selectDimension, threshold: 2048,changeNumber:changeNumber)
        
        self.present(game, animated: true , completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.	
    }


}

