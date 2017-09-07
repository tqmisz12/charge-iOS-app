//
//  SettingTableViewController.swift
//  final
//
//  Created by 盧與明 on 2016/6/15.
//  Copyright © 2016年 bo ren. All rights reserved.
//

import UIKit

class SettingTableViewController: UITableViewController {

    @IBOutlet weak var alertSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertSwitch.setOn(false, animated: true)
    }

    @IBAction func alertSwitchChanged(sender: UISwitch) {
        if (sender.on) {
            openAlert()
        } else {
            return
        }
    }
    
    func openAlert() {
        
        let currentDate : NSDate = NSDate()
        let timeComp: NSDateComponents = NSDateComponents()
        
        timeComp.hour = 12
        timeComp.minute = 50
        timeComp.timeZone = NSTimeZone.defaultTimeZone()

        let calender: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierRepublicOfChina)!
        let date: NSDate = calender.dateFromComponents(timeComp)!
        
        let notification: UILocalNotification = UILocalNotification()
        notification.category = "FIRST CATEGORY"
        notification.alertBody = "Big trouble!! You spent too much money!"
        notification.alertAction = "Alert"
        notification.fireDate = date
        notification.timeZone = NSTimeZone.defaultTimeZone()
        notification.repeatInterval = NSCalendarUnit.NSMinuteCalendarUnit
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    func openBalanceSheet() {
        
    }
    
}
