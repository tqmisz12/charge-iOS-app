//
//  NewData.swift
//  final
//
//  Created by bo ren on 2016/6/12.
//  Copyright © 2016年 bo ren. All rights reserved.
//

import UIKit

class NewData: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var pickerviewmoney: UIPickerView!
    @IBOutlet weak var pickerviewkind: UIPickerView!
    @IBOutlet weak var datepicker: UIDatePicker!
    @IBOutlet weak var money: UITextField!
    @IBOutlet weak var others: UITextView!
    
    var dataArrayMoney = [String]()
    var dataArrayKind = [String]()
    var databaseController:DatabaseManager?

    var value3 = 0
    var value4 = 0
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.databaseController = DatabaseManager(fileName: "record")
        self.pickerviewmoney.delegate = self
        self.pickerviewmoney.dataSource = self
        dataArrayMoney = ["收入","支出"]
        self.money.keyboardType = UIKeyboardType.NumberPad
        self.pickerviewkind.delegate = self
        self.pickerviewkind.dataSource = self
        dataArrayKind = ["早餐","午餐","下午茶","晚餐","衣服","住宿","交通","教育","娛樂","其他"]
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.tag==0){
            return dataArrayMoney.count
        }
        else{
            return dataArrayKind.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView.tag==0){
            return dataArrayMoney[row]
        }
        else {
            return dataArrayKind[row]
        }
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView.tag==0){
            value3 = row
        }
        else {
            value4 = row
        }

    }

    @IBAction func SaveData(sender: UIButton) {
        let cost:Double!
        if money.text == "" {
            return
        }
        if value3 == 1 {
            cost = Double(money.text!)! * -1
        }
        else {
            cost = Double(money.text!)!
        }
        self.databaseController?.addchargeData(earnOrSpend: dataArrayMoney[value3], kind: dataArrayKind[value4], money:cost, others: others.text!, time:NewData.normalizeDate(datepicker.date))
        self.databaseController?.getDetailData()
        
        dismissVC()
    }
    
    static func normalizeDate(date:NSDate) -> NSDate {
        let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        return cal.startOfDayForDate(date)
    }
    
    func dismissVC(){
        navigationController?.popViewControllerAnimated(true)
    }
    
    
    

}

