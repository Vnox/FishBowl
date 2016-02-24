//
//  TableViewController.swift
//  αBaro
//
//  Created by Leon on 12/14/15.
//  Copyright © 2015 Ethereo. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController, TableViewCellDelegate, UITextFieldDelegate {
    

    // REFRESH CONTROL RELATED //
    
    var myRefreshControl: UIRefreshControl!
    
    var events = [Event]()
    var eventData = [NSManagedObject]()
    let nonurgentImg = UIImage(named: "urgentIndiGr")
    let urgentImg = UIImage(named: "urgentIndi")

    var detailRow = [Int]()
    var managedContext: NSManagedObjectContext!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        // load event list
        loadEvents()
        
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        swipeGesture.numberOfTouchesRequired = 1
        swipeGesture.direction = .Down
        view.addGestureRecognizer(swipeGesture)
        
        myRefreshControl = UIRefreshControl()
        self.tableView.addSubview(myRefreshControl)
        self.myRefreshControl.addTarget(self, action: "addEvents:", forControlEvents: UIControlEvents.ValueChanged)
        
        
        
        }
    
    func addEvents(sender: AnyObject){
        
        NSLog("ADDING EVENTS")
        
        let customIcon = UIImage(named: "lightbulb")
        let alertview = JSSAlertView().show(self, title: "New Event", text: "This is still under construction. Don't press me yet : )", buttonText: "Cancel",cancelButtonText: "Confirm", color: UIColorFromHex(0x496FBE, alpha: 1), iconImage: customIcon)
        alertview.setTitleFont("AvenirNext-Regular")
        alertview.setTextFont("AvenirNext-Regular")
        alertview.setButtonFont("AvenirNext-Regular")
        alertview.addAction(confirmEvent)
        alertview.setTextTheme(.Light)
        alertview.getTextfield().delegate = self
        alertview.getTextfield().returnKeyType = UIReturnKeyType.Go
        //self.myRefreshControl.endRefreshing()
        
    
    }
    
    func confirmEvent(){
        NSLog("action")
        self.loadEvents()
        self.tableView.reloadData()
        self.myRefreshControl.endRefreshing()
        
    }
    
    
    

    
    
    func loadEvents() {
        events = []

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
    
    func updateEvents(){
        // should be implemented by maple someday
        
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
        //NSLog("SELECTED")
        
        // If detail cell, then response nothing
        if(detailRow.contains(indexPath.row)){
            return
        }
        
        let selectedCell:EventCell = tableView.cellForRowAtIndexPath(indexPath)! as! EventCell
        
        if(selectedCell.showedDetail == false){
        
            //Below are adding mew detail cell if possible
            events.insert(Event(name: "DETAILS", timeRemaining: 0.00, priority: false), atIndex: indexPath.row + 1)
            
            detailRow.insert(indexPath.row + 1, atIndex: 0)
            for(var i = 0; i < detailRow.count; i++){
                if(detailRow[i] > indexPath.row+1 ){
                    detailRow[i]++
                }
            }
            
            tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)], withRowAnimation: .Fade)
            selectedCell.showedDetail = true
            return
            
        }
        
        else{
            
            let toremove = detailRow.indexOf(indexPath.row + 1)
            if(toremove != nil){detailRow.removeAtIndex(toremove!)}
       
            
            
            events.removeAtIndex(indexPath.row + 1)
            tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)], withRowAnimation: .Fade)
            
            selectedCell.showedDetail = false
            
        }
        
        

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
        
        let indexPathForRow = NSIndexPath(forRow: index!, inSection: 0)
        
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext!
        context.deleteObject(eventData[indexPathForRow.row] as NSManagedObject)
        eventData.removeAtIndex(indexPathForRow.row)
        do{
            try context.save()
        }catch let error as NSError{
            print("Can't delete: \(error)")
        }

        
        // use the UITableView to animate the removal of this row
        tableView.beginUpdates()
        //let indexPathForRow = NSIndexPath(forRow: index!, inSection: 0)
        tableView.deleteRowsAtIndexPaths([indexPathForRow], withRowAnimation: .Fade)
        tableView.endUpdates()    
    }
    

    


   }
