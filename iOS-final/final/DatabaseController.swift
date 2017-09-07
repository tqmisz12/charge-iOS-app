//
//  DatabaseController.swift
//  final
//
//  Created by  Bryant on 2016/6/13.
//  Copyright © 2016年 bo ren. All rights reserved.
//

import Foundation
import SQLite

protocol DatabaseController {
    init(fileName: String)
    
    func addchargeData(earnOrSpend earnOrSpend: String, kind: String, money: Double,others:String,time:NSDate)
    func addNotificationTimeData(hour hour: String, minute: String)
}

// Database ------------------------------------------------------------------------------------------------------------

struct kindSum {
    
    init(kind:String, cost:Double){
        self.cost = cost
        self.kind = kind
    }
    
    let cost:Double
    let kind:String
}

struct QueryResult {
    let kind:String
    let money:Double
    let date:NSDate
    let EoS:String
    let others:String
    
    init(kind:String , money:Double, date:NSDate, EoS:String = "",others:String = ""){
        self.kind = kind
        self.money = money
        self.date = date
        self.EoS = EoS
        self.others = others
    }
}

struct dateDetail {
    var date:NSDate
    var detailData:[kindSum]
    init(date:NSDate,detailData:[kindSum]){
        self.date = date
        self.detailData = detailData
    }
}



struct ChargeRecorderTable {
    static let table = Table("chargeRecorder")
    static let earnOrSpend = Expression<String>("earnOrSpend")
    static let kind = Expression<String>("kind")
    static let money = Expression<Double>("money")
    static let others = Expression<String>("others")
    static let time = Expression<NSDate>("time")
    static let stamp = Expression<Double>("timestamp")
}

struct NotificationTable {
    static let table = Table("notificationTime")
    static let hour = Expression<String>("hour")
    static let minute = Expression<String>("minute")
    static let stamp = Expression<Double>("timestamp")

}

struct DatabaseManager: DatabaseController {
    
    let fileName: String
    var filePath: String {
        let documentFolder = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
        let filePath = (documentFolder as NSString).stringByAppendingPathComponent("\(self.fileName).sqlite3")
        return filePath
    }
    
    var databaseConnection: Connection?
    
    
    init(fileName: String) {
        self.fileName = fileName
        
        
        self.openDatabase()
        print(self.databaseConnection)
    }
    
    // MARK: - Method

    
    private mutating func openDatabase() {
            do {
                self.databaseConnection = try Connection(self.filePath)
                try self.databaseConnection!.run(ChargeRecorderTable.table.create(ifNotExists: true) { t in
                    t.column(ChargeRecorderTable.earnOrSpend)
                    t.column(ChargeRecorderTable.kind)
                    t.column(ChargeRecorderTable.money)
                    t.column(ChargeRecorderTable.others)
                    t.column(ChargeRecorderTable.time)
                    t.column(ChargeRecorderTable.stamp)
                    })
                
                try self.databaseConnection!.run(ChargeRecorderTable.table.createIndex([ChargeRecorderTable.stamp],
                    ifNotExists: true))
            } catch {
                print("Cannot create database")
                exit(1)
            }
        
            do {
                self.databaseConnection = try Connection(self.filePath)
                try self.databaseConnection!.run(NotificationTable.table.create(ifNotExists: true) { t in
                    t.column(NotificationTable.hour)
                    t.column(NotificationTable.minute)
                    t.column(NotificationTable.stamp)
                    })
                try self.databaseConnection!.run(NotificationTable.table.createIndex([NotificationTable.stamp],
                    ifNotExists: true))
            } catch {
                print("Cannot create notification table.")
                exit(1)
            }
    }
    
    func addchargeData(earnOrSpend earnOrSpend: String, kind: String, money: Double,others:String,time:NSDate) {
        if self.databaseConnection == nil {
            print("add fail")
            return
        }
            do {
                try self.databaseConnection!.run(ChargeRecorderTable.table.insert(
                    ChargeRecorderTable.earnOrSpend <- earnOrSpend,
                    ChargeRecorderTable.kind <- kind,
                    ChargeRecorderTable.money <- money,
                    ChargeRecorderTable.others <- others,
                    ChargeRecorderTable.time <- time,
                    ChargeRecorderTable.stamp <- NSDate().timeIntervalSince1970
                    ))
            } catch {
                print("Cannot insert data")
                exit(1)
            }
        
    }
    
    func addNotificationTimeData(hour hour: String, minute: String) {
        if self.databaseConnection == nil {
            print("add failed")
            return
        }
        
        do {
            try self.databaseConnection!.run(NotificationTable.table.insert (
                NotificationTable.hour <- hour,
                NotificationTable.minute <- minute,
                NotificationTable.stamp <- NSDate().timeIntervalSince1970
                ))
        } catch {
            print("Cannot insert data")
            exit(1)
        }
    }
    
    func selectAllData(){
        if self.databaseConnection == nil {
            return
        }
            do {
                for _ in try self.databaseConnection!.prepare(ChargeRecorderTable.table.select(ChargeRecorderTable.money,ChargeRecorderTable.kind,ChargeRecorderTable.time).group(ChargeRecorderTable.time)){
  //                  print ("group: EoS: \(record[ChargeRecorderTable.kind]) money: \(record[ChargeRecorderTable.money]) date: \(record[ChargeRecorderTable.time])")
                }
                
            } catch {
                print ("Cannot query data")
                exit(1)
            }
        }
    
    func getDetailData() -> [dateDetail]{
        do {
            var dateDetailDict = [NSDate:[kindSum]]()
            var dateDetailArray:[dateDetail] = []
            for record in try self.databaseConnection!.prepare(ChargeRecorderTable.table.select(ChargeRecorderTable.kind,ChargeRecorderTable.money.sum,ChargeRecorderTable.time).group(ChargeRecorderTable.time,ChargeRecorderTable.kind).order(ChargeRecorderTable.time.desc,ChargeRecorderTable.kind.asc)){
                let tmpKindSum = kindSum(kind: record[ChargeRecorderTable.kind],cost: record[ChargeRecorderTable.money.sum]!)
                if dateDetailDict[record[ChargeRecorderTable.time]] == nil {
                    dateDetailDict[record[ChargeRecorderTable.time]] = []
                }
                dateDetailDict[record[ChargeRecorderTable.time]]?.append(tmpKindSum)
            }
            
            for (date,ksArray) in dateDetailDict {
                let _dateDetail = dateDetail(date: date, detailData: ksArray)
                dateDetailArray.append(_dateDetail)
            }
            let sortedArray = dateDetailArray.sort{ (A:dateDetail,B:dateDetail) -> Bool in
                return A.date.compare(B.date) == NSComparisonResult.OrderedDescending
            }
            print(sortedArray)
            return sortedArray
        }catch{
            print("cannot get detail data!")
            exit(1)
        }
    }
    
    func getDataToday() -> [QueryResult] {
        if self.databaseConnection == nil {
            return []
        }
        do{
            var resultArray:[QueryResult] = []
            for record in try self.databaseConnection!.prepare(ChargeRecorderTable.table.select(ChargeRecorderTable.time,ChargeRecorderTable.kind,ChargeRecorderTable.money)){
                if(record[ChargeRecorderTable.time] == NewData.normalizeDate(NSDate())){
                    let result = QueryResult(kind: record[ChargeRecorderTable.kind], money: record[ChargeRecorderTable.money], date: record[ChargeRecorderTable.time])
                    resultArray.append(result)
                }
            }
            return resultArray
        } catch {
            print ("Cannot query data")
            exit(1)
        }
    }
    
    func getDataChooseDate() -> [QueryResult] {
        if self.databaseConnection == nil{
            return []
        }
        do {
            var resultArray:[QueryResult] = []
            for record in try self.databaseConnection!.prepare(ChargeRecorderTable.table.select(ChargeRecorderTable.time,ChargeRecorderTable.kind,ChargeRecorderTable.money)){
                let result = QueryResult(kind: record[ChargeRecorderTable.kind], money: record[ChargeRecorderTable.money], date: record[ChargeRecorderTable.time])
                resultArray.append(result)
            }
            return resultArray
        } catch {
            print ("Cannot query data")
            exit(1)
        }
    }
    
    func getMonthData()-> [QueryResult] {
        if self.databaseConnection == nil{
            return []
        }
        let cal: NSCalendar = NSCalendar.currentCalendar()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        let components = cal.components([.Year, .Month], fromDate: NSDate())
        let startOfMonth = cal.dateFromComponents(components)!
        do {
            var resultArray:[QueryResult] = []
            for record in try self.databaseConnection!.prepare(ChargeRecorderTable.table.select(ChargeRecorderTable.time,ChargeRecorderTable.kind,ChargeRecorderTable.money)){
                if(dateFormatter.stringFromDate(startOfMonth) == dateFormatter.stringFromDate(record[ChargeRecorderTable.time])){
                    if(record[ChargeRecorderTable.money]<0){
                        let result = QueryResult(kind: record[ChargeRecorderTable.kind], money: record[ChargeRecorderTable.money], date: record[ChargeRecorderTable.time])
                        resultArray.append(result)
                    }
                }
            }
            return resultArray
        } catch {
            print ("Cannot query data")
            exit(1)
        }
    }

}

