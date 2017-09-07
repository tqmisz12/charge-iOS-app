//
//  DetailTableViewController.swift
//  final
//
//  Created by  Bryant on 2016/6/14.
//  Copyright © 2016年 bo ren. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController {
    var DetailDict:[dateDetail]!
    var databaseController:DatabaseManager?
    
    static let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.databaseController = DatabaseManager(fileName: "record")
        self.DetailDict = (self.databaseController?.getDetailData())!
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
            return self.DetailDict.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.DetailDict[section].detailData.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DetailCell", forIndexPath: indexPath)
        let detailData = self.DetailDict[indexPath.section].detailData[indexPath.row]
        let kindLabel = self.view.viewWithTag(20) as!UILabel
        let costLabel = self.view.viewWithTag(30) as!UILabel
        kindLabel.text = detailData.kind
        costLabel.text = String(detailData.cost)
        if detailData.cost < 0 {
            costLabel.textColor = UIColor.redColor()
        }
        else {
            costLabel.textColor = UIColor.blueColor()
        }
        // Configure the cell...

        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return DetailTableViewController.dateFormatter.stringFromDate(self.DetailDict[section].date)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.databaseController = DatabaseManager(fileName: "record")
        self.DetailDict = (self.databaseController?.getDetailData())!
        tableView.reloadData()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
