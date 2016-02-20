//
//  TableViewController.swift
//  αBaro
//
//  Created by Leon on 12/14/15.
//  Copyright © 2015 Ethereo. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController, TableViewCellDelegate {
    

    

    var events = [Event]()
    var eventData = [NSManagedObject]()
    let nonurgentImg = UIImage(named: "urgentIndiGr")
    let urgentImg = UIImage(named: "urgentIndi")
    var detailRow = [Int]()
    var managedContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        // load event list
        loadEvents()
        
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        swipeGesture.numberOfTouchesRequired = 1
        swipeGesture.direction = .Down
        view.addGestureRecognizer(swipeGesture)
        
        //self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 50.0, 0.0)
        
        
        // Do any additional setup after loading the view.

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    

    
    
    func loadEvents() {
        
//        let event1:Event = Event(name: "Finish math Homwwork", timeRemaining: 4.00, priority: false)
//        let event2:Event = Event(name: "CSE Test Review", timeRemaining: 2.00, priority: false)
//        let event3:Event = Event(name: "Getting ready for the driving test", timeRemaining: 1.00, priority: true)
//        events += [event1, event2, event3]
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Entity")
        
        do{
            let results =
            try managedContext!.executeFetchRequest(fetchRequest)
            eventData = results as! [NSManagedObject]
            for var i=0; i<eventData.count; i++ {
                let tmpEvent = eventData[i]
                let eventObj: Event = Event(name: (tmpEvent.valueForKey("name") as? String)!, timeRemaining: 4.00, priority: false)
                events.append(eventObj)
            }
            print("\(eventData)")
        } catch let error as NSError {
            print("could not fetch \(error), \(error.userInfo)")
        }
        
    }
    
    // Hide the status bar
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return events.count
    }
    
    func handleSwipes(sender:UISwipeGestureRecognizer){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "EventCell"
        let decellIdentifier = "DetailCell"
        
        if(detailRow.contains(indexPath.row)){
            
            let decell = tableView.dequeueReusableCellWithIdentifier(decellIdentifier, forIndexPath: indexPath)
                as! DetailCell
            return decell
            
        }else{
        
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
            as! EventCell
            
            // Fetches events 
            let event = events[indexPath.row]
            
            cell.EventName.text = event.name
            cell.hoursLeft.text = String(Int(event.timeRemaining)) + "h"

            cell.showedDetail = event.showedDetail
 
        if(event.priority){
            
            cell.urgentImg.image = nonurgentImg
            
        }else{
            
            cell.urgentImg.image = urgentImg
            
        
            }
            cell.delegate = self
            cell.toDoItem = event
        
        return cell
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedCell:EventCell = tableView.cellForRowAtIndexPath(indexPath)! as! EventCell
        
        if(selectedCell.showedDetail == false){
        
            //Below are adding mew detail cell if possible
            events.insert(Event(name: "DETAILS", timeRemaining: 0.00, priority: false), atIndex: indexPath.row + 1)
            
            detailRow.insert(indexPath.row + 1, atIndex: 0)
            
            tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)], withRowAnimation: .Fade)
            selectedCell.showedDetail = true
            
        }else{
            
            detailRow.removeAll()
            
            events.removeAtIndex(indexPath.row + 1)
            tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)], withRowAnimation: .Fade)
            
            selectedCell.showedDetail = false
            
        }
        
        

    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //set height
        if(detailRow.contains(indexPath.row) ){
            return  CGFloat(35.0)
        }
        return  CGFloat(70.0)
    }
    
    func toDoItemDeleted(toDoItem: Event) {
        // Delete everything in this method
        
        let index = events.indexOf(toDoItem)
        if index == NSNotFound { return }
        events.removeAtIndex(index!)
        
        // use the UITableView to animate the removal of this row
        tableView.beginUpdates()
        let indexPathForRow = NSIndexPath(forRow: index!, inSection: 0)
        tableView.deleteRowsAtIndexPaths([indexPathForRow], withRowAnimation: .Fade)
        tableView.endUpdates()    
    }

    


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
