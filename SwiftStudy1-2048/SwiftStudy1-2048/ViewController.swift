//
//  ViewController.swift
//  SwiftStudy1-2048
//
//  Created by huntian on 2018/4/16.
//  Copyright © 2018年 huntian. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    let pickerView = UIPickerView()
    
    
    //设置选择框的列数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    //设置选择框的行数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
      
    }
    
    //设置选择框各选项的内容，继承于UIPickerViewDelegate协议
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int,
                    forComponent component: Int) -> String? {
        let pickerViewArray : Array<String> = ["军衔","普通","猪宝宝"]
        let pickerViewArray2 : Array<String> = ["简单","正常"]
        return String(pickerViewArray[row])+"-"+String(pickerViewArray2[component])
    }
    
    //触摸按钮时，获得被选中的索引
    @objc func getPickerViewValue(){
        let message = String(pickerView.selectedRow(inComponent: 0)) + "-"
            + String(pickerView.selectedRow(inComponent: 1)) //+ "-"
            //+ String(pickerView.selectedRow(inComponent: 2))
        let alertController = UIAlertController(title: "被选中的索引为",
                                                message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }

    
    @IBAction func selectButton(_ sender: UIButton) {
        //将dataSource设置成自己
        pickerView.dataSource = self
        //将delegate设置成自己
        pickerView.delegate = self
        pickerView.center = self.view.center
     //   pickerView.frame = CGRect(x: 0, y: 200, width: 300, height: 300)
        //设置选择框的默认值
        pickerView.selectRow(1,inComponent:0,animated:true)
        pickerView.selectRow(2,inComponent:1,animated:true)
        //  pickerView.selectRow(3,inComponent:2,animated:true)
        self.view.addSubview(pickerView)
       
       
        
        //建立一个按钮，触摸按钮时获得选择框被选择的索引
        let button = UIButton(frame:CGRect(x:200, y:500, width:100, height:30))
       // button.center = self.view.center
        button.backgroundColor = UIColor.blue
        button.setTitle("获取信息",for:.normal)
        button.addTarget(self, action:#selector(ViewController.getPickerViewValue),
                         for: .touchUpInside)
      
        self.view.addSubview(button)
    }
    
    @IBAction func setupGame(_ sender: UIButton) {
//        let game = NumbertailGameController (demension: 4, threshold: 2048)
        
        let game = NumbertailGameController.init(dimension: 4, threshold: 2048)
        
        self.present(game, animated: true , completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.	
    }


}

