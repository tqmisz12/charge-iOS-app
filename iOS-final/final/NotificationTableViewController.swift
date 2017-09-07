//
//  NotificationTableViewController.swift
//  final
//
//  Created by 盧與明 on 2016/6/15.
//  Copyright © 2016年 bo ren. All rights reserved.
//

import UIKit

class NotificationTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    var hourPicker = UIPickerView()
    var minutePicker = UIPickerView()
    @IBOutlet weak var notificationSwitch: UISwitch!

    var DBMS: DatabaseManager?
    
    @IBOutlet weak var hourTextField: UITextField!
    @IBOutlet weak var minuteTextField: UITextField!
    
    var hours = ["00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23"]
    
    var minutes = ["00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50", "51", "52", "53", "54", "55", "56", "57", "58", "59"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationSwitch.setOn(false, animated: true)
//        self.DBMS = DatabaseManager(fileName: "")
    
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "drawAShape:", name: "actionOnePressed", object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "drawAMessage:", name: "actionTwoPressed", object: nil)

        
        self.hourPicker.delegate = self
        self.minutePicker.delegate = self
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor(red: 0/255, green: 0/255, blue: 180/255, alpha: 1)
        toolBar.sizeToFit()
        
        let toolBar2 = UIToolbar()
        toolBar2.barStyle = UIBarStyle.Default
        toolBar2.translucent = true
        toolBar2.tintColor = UIColor(red: 0/255, green: 0/255, blue: 180/255, alpha: 1)
        toolBar2.sizeToFit()
        
        let hourDoneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(NotificationTableViewController.doneHrPicker))
        let minuteDoneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(NotificationTableViewController.doneMinPicker))
        
        toolBar.setItems([hourDoneButton], animated: false)
        toolBar.userInteractionEnabled = true
        
        toolBar2.setItems([minuteDoneButton], animated: false)
        toolBar2.userInteractionEnabled = true
        
        hourPicker.dataSource = self
        hourTextField.inputView = hourPicker
        hourTextField.inputAccessoryView = toolBar
        
        minutePicker.dataSource = self
        minuteTextField.inputView = minutePicker
        minuteTextField.inputAccessoryView = toolBar2
        
        hourTextField.addTarget(nil, action: #selector(NotificationTableViewController.closeKeyBoard), forControlEvents: .EditingDidEndOnExit)
        minuteTextField.addTarget(nil, action: #selector(NotificationTableViewController.closeKeyBoard), forControlEvents: .EditingDidEndOnExit)
        
    }
    
//    func drawAShape(notification: NSNotification) {
//        var view: UIView = UIView(frame: CGRectMake(10, 10, 100, 100))
//        view.backgroundColor = UIColor.redColor()
//        
//        self.view.addSubview(view)
//    }
//    
//    func showAMessage(notification: NSNotification) {
//        var message: UIAlertController = UIAlertController(title: "A notification message.", message: "Hello Bro!", preferredStyle: UIAlertControllerStyle.Alert)
//        message.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
//        
//        self.presentViewController(message, animated: true, completion: nil)
//    }
    
    @IBAction func notificationSwitchChanged(sender: UISwitch) {
        if (sender.on) {
            openNotification()
        } else {
            return
        }
    }
    
    func openNotification() {
        let currentDate : NSDate = NSDate()
        let dateComp: NSDateComponents = NSDateComponents()
        
        dateComp.hour = 12
        dateComp.minute = 50
        dateComp.timeZone = NSTimeZone.defaultTimeZone()
        
        
        
        let calender: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierRepublicOfChina)!
        let date: NSDate = calender.dateFromComponents(dateComp)!
        
        let notification: UILocalNotification = UILocalNotification()
        notification.category = "FIRST CATEGORY"
        notification.alertBody = "Hello! Remember to add your new charge to our app. Thank you!"
        notification.alertAction = "Alert"
        notification.fireDate = date
        notification.timeZone = NSTimeZone.defaultTimeZone()
        notification.repeatInterval = NSCalendarUnit.NSDayCalendarUnit
        
        print(date)
        print(currentDate)
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    func doneHrPicker() {
        hourTextField.resignFirstResponder()
    }
    
    func doneMinPicker() {
        minuteTextField.resignFirstResponder()
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView == self.hourPicker) {
            return hours.count
        } else if (pickerView == self.minutePicker) {
            return minutes.count
        }
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView == self.hourPicker) {
            hourTextField.text = hours[row]
        } else if (pickerView == self.minutePicker) {
            minuteTextField.text = minutes[row]
        }
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.hourPicker {
            return hours[row]
        } else if pickerView == self.minutePicker {
            return minutes[row]
        }
        return ""
    }
    
    func closeKeyBoard() {
        self.view.endEditing(true)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        closeKeyBoard()
    }

    @IBAction func saveTime(sender: UIBarButtonItem) {
        if hourTextField.text == "" || minuteTextField.text == "" {
            return
        } else {
            print (hourTextField.text)
            print (minuteTextField.text)
            self.DBMS?.addNotificationTimeData(hour: hourTextField.text!, minute: minuteTextField.text!)
        }
        
    }

}
