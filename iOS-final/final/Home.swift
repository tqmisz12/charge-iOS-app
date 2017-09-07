//
//  Home.swift
//  final
//
//  Created by bo ren on 2016/6/14.
//  Copyright © 2016年 bo ren. All rights reserved.
//

import UIKit
import FSCalendar

class Home: UIViewController {
    
    @IBOutlet weak var Scrollview: UIScrollView!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    
    let symbol: String = "$"
    var databaseController:DatabaseManager?

    @IBOutlet weak var monthtotalspend: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.databaseController = DatabaseManager(fileName:"record")
        addTodayData()
        startOfMonth()
        
        calendar.scrollDirection = .Vertical
        calendar.appearance.caseOptions = [.HeaderUsesUpperCase,.WeekdayUsesUpperCase]
    }
    func addTodayData() {
        var number: CGFloat = 8
        var results = [QueryResult]()
        let labelGroup = UIStackView()
        labelGroup.axis = .Vertical
        results = (self.databaseController?.getDataToday())!
        if(self.Scrollview.subviews.count != 0){
            for view in self.Scrollview.subviews {
                view.removeFromSuperview()
            }
        }
        for result in results {
            let stack = UIStackView()
            stack.axis = .Horizontal
            let label = UILabel(frame: CGRectMake(200 , 300, 140, 30))
            label.center = CGPoint(x: view.center.x-50,y: 20+number)
            label.textAlignment = NSTextAlignment.Center
            label.text = result.kind
            let label2 = UILabel(frame: CGRectMake(200 , 300, 140, 30))
            label2.center = CGPoint(x: view.center.x+50, y: 20+number)
            label2.textAlignment = NSTextAlignment.Center
            label2.text = symbol.stringByAppendingString(String(result.money))
            stack.addSubview(label)
            stack.addSubview(label2)
            labelGroup.addSubview(stack)
            number = number + 30
        }
        self.Scrollview.addSubview(labelGroup)
    }
    override func viewWillAppear(animated: Bool) {
        self.Scrollview.contentSize = CGSize(width: self.view.frame.width, height: 500)
        super.viewWillAppear(animated)
        self.databaseController = DatabaseManager(fileName: "record")
        addTodayData()
        startOfMonth()
    }
    
    func minimumDateForCalendar(calendar: FSCalendar) -> NSDate {
        return calendar.dateWithYear(2015, month: 1, day: 1)
    }
    
    func maximumDateForCalendar(calendar: FSCalendar) -> NSDate {
        return calendar.dateWithYear(2020, month: 10, day: 31)
    }
    
    func calendarCurrentPageDidChange(calendar: FSCalendar) {
        print("change page to \(calendar.stringFromDate(calendar.currentPage))")
    }
    
    func calendar(calendar: FSCalendar, didSelectDate date: NSDate) {
        //        print("calendar did select date \(calendar.stringFromDate(date))")
        var number: CGFloat = 8
        var results = [QueryResult]()
        let labelGroup = UIStackView()
        labelGroup.axis = .Vertical
        results = (self.databaseController?.getDataChooseDate())!
        if(self.Scrollview.subviews.count != 0){
            for view in self.Scrollview.subviews {
                view.removeFromSuperview()
            }
        }
        for result in results {
            if(date == result.date){
                let stack = UIStackView()
                stack.axis = .Horizontal
                let label = UILabel(frame: CGRectMake(200 , 300, 140, 30))
                label.center = CGPoint(x: view.center.x-50,y: 20+number)
                label.textAlignment = NSTextAlignment.Center
                label.text = result.kind
                let label2 = UILabel(frame: CGRectMake(200 , 300, 140, 30))
                label2.center = CGPoint(x: view.center.x+50, y: 20+number)
                label2.textAlignment = NSTextAlignment.Center
                label2.text = symbol.stringByAppendingString(String(result.money))
                stack.addSubview(label)
                stack.addSubview(label2)
                labelGroup.addSubview(stack)
                number = number + 30
            }
        }
        self.Scrollview.addSubview(labelGroup)
    }
    func calendar(calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarHeightConstraint.constant = bounds.height
        view.layoutIfNeeded()
    }
    
    func startOfMonth() {
        let tmp: String = "本月目前支出     "
        var results = [QueryResult]()
        results = (self.databaseController?.getMonthData())!
        var totalspend: Double = 0
        for result in results {
            totalspend += result.money
        }
        totalspend *= -1
        monthtotalspend.text! = tmp.stringByAppendingString(String(totalspend))
    }
}

