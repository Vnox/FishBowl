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
    

    /* Refresh Control Related */
    
    var myRefreshControl: UIRefreshControl!
    var myLoaderView:UIView!
    var myLoader:UIImageView!
    
    /* Other Stuff */
    
    var indicatorImageView: UIImageView!
    
    var events = [Event]()
    var eventData = [NSManagedObject]()
    let investImage = UIImage(named: "urgentIndiGr")
    let haveFunImage = UIImage(named: "urgentIndi")
    let staticTimeImage = UIImage(named: "IndicatorBlue")

    var detailRow = [Int]()
    var managedContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadEvents()
        
        // if first launch
        if(eventData.count == 0){
            // save the fixed event
            self.saveFixedEvent("Fixed time", time: 8.0)
            self.saveFixedEvent("Entertainment", time: 0.0)
        }
        
        // load the event list
        self.loadToEventList()
        
        //let fixedEvent = Event(name: "Fixed Event", timeRemaining: 8.0, tagColor: 2, showedDetail: false)
        //events.append(fixedEvent)
        
        // get todayWidget shared info path
        //let sharedDefaults = NSUserDefaults(suiteName: "group.com.ethereo.lifebaro")
        
        
        // get number of tasks
        //sharedDefaults?.setObject("\(eventData.count)", forKey: "StringKey")
        //sharedDefaults?.synchronize()
        
        // Do anything after load events
        
        self.indicatorImageView = UIImageView(image: UIImage(named: "pullIndicator"))
        self.indicatorImageView.frame = CGRect(x: 0, y: 0, width: 240, height: 80)
        self.indicatorImageView.center.x = self.view.center.x
        self.indicatorImageView.center.y += 10
        NSLog("NUM:" + String(events.count))
        if(events.count != 0){
            self.indicatorImageView.alpha = 0.0
        }else if(tableView.numberOfRowsInSection(0) == 0){
            self.indicatorImageView.alpha = 1.0
        }
        self.view.addSubview(indicatorImageView)
        
        tableView.delegate = self
        tableView.dataSource = self

        
        self.tableView.addPullToRefresh( { [weak self] in
            // refresh code
            let customIcon = UIImage(named: "lightbulb")
            let alertview = JSSAlertView().show(self!, title: "New Event", text: "This is still under construction. Don't press me yet : )", buttonText: "Cancel",cancelButtonText: "Confirm", color: UIColorFromHex(0x496FBE, alpha: 1), iconImage: customIcon)
            alertview.setTitleFont("AvenirNext-Regular")
            alertview.setTextFont("AvenirNext-Regular")
            alertview.setButtonFont("AvenirNext-Regular")
            alertview.addAction(self!.confirmEvent)
            alertview.setTextTheme(.Light)
            alertview.getTextfield().delegate = self
            alertview.getTextfield().returnKeyType = UIReturnKeyType.Go

            
            self?.tableView.reloadData()
            
            },refreshPull: { //[weak self] in
               //Pull code
                NSLog(" -> -> -> ")
                self.dismissViewControllerAnimated(true, completion: nil)
            
            })
        
        
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
        //self.myRefreshControl.endRefreshing()
        self.tableView.stopPullToRefresh()
        self.indicatorImageView.alpha = 0.0
        
    }
    
    func saveFixedEvent(name:String, time: Double){
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let entity =  NSEntityDescription.entityForName("Entity",inManagedObjectContext:managedContext!)
        
        let person = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext: managedContext)
        
        person.setValue(name, forKey: "name")
        person.setValue(time, forKey: "calculatedResult")
        
        
        do {
            try managedContext!.save()
            eventData.append(person)
            print("saved!")
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    // load event by Ye's power
    func loadEvents() {
        events = []

        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Entity")
        
        
        do{
            let results =
            try managedContext!.executeFetchRequest(fetchRequest)
            eventData = results as! [NSManagedObject]
//            for var i=0; i<eventData.count; i++ {
//                let tmpEvent = eventData[i]
//                // get the task name
//                let eventObj: Event = Event(name: (tmpEvent.valueForKey("name") as? String)!, timeRemaining: 4.00, tagColor: 2)
//                events.append(eventObj)
//            }
            print("\(eventData)")
        } catch let error as NSError {
            print("could not fetch \(error), \(error.userInfo)")
        }
        
    }
    
    func loadToEventList(){
        for var i=eventData.count-1; i>=0; i-- {
            let tmpEvent = eventData[i]
            let eventName = tmpEvent.valueForKey("name") as! String
            let eventTime = tmpEvent.valueForKey("calculatedResult") as! Double
            if (eventName == "Fixed time"){
                // set the event object
                let eventObj = Event(name: eventName, timeRemaining: 8.0, tagColor: 2)
                self.events.append(eventObj)
            }
            else if (eventName == "Entertainment"){
                // set the event object
                let eventObj = Event(name: eventName, timeRemaining: eventTime, tagColor: 2)
                self.events.append(eventObj)
            }
            else{
                let eventObj = Event(name: eventName, timeRemaining: eventTime, tagColor: 1)
                self.events.append(eventObj)
            }
        }
    }
    
    // update the event by Ye's power
    func updateEvent(index:Int, newName:String, newTime:NSData){
        // create a fetch request
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Entity")
        
        do{
            let currentlist = try managedContext!.executeFetchRequest(fetchRequest)
            eventData = currentlist as! [NSManagedObject]
            let updatedEvent = eventData[index]
            // update event name
            updatedEvent.setValue(newName, forKey: "name")
            // update event time
            updatedEvent.setValue(newTime, forKey: "dueDate")
            
            // save the change
            do{
                try updatedEvent.managedObjectContext?.save()
            }catch{
                let saveError = error as NSError
                print(saveError)
            }
        } catch let error as NSError {
            print("could not update \(error), \(error.userInfo)")
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
    

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "EventCell"
        let decellIdentifier = "DetailCell"
        
        if(detailRow.contains(indexPath.row)){
            
            let decell = tableView.dequeueReusableCellWithIdentifier(decellIdentifier, forIndexPath: indexPath)
                as! DetailCell
            
            // Configure it //
            
            let beforeCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: indexPath.row - 1, inSection: indexPath.section)) as! EventCell
            
            decell.myHour = beforeCell.myHour
            decell.myMin = beforeCell.myMin
            decell.mySec = beforeCell.mySec
            
            return decell
            
        }else{
        
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
            as! EventCell
            
            // Fetches events 
            let event = events[indexPath.row]
            
            cell.EventName.text = event.name
            cell.hoursLeft.text = String(Int(event.timeRemaining)) + "h"

            cell.showedDetail = event.showedDetail
 
        if(event.tagColor == 0){
            
            cell.urgentImg.image = investImage
            
        }else if(event.tagColor == 1){
            
            cell.urgentImg.image = haveFunImage
            
        
        }else if(event.tagColor == 2){
            
            cell.urgentImg.image = staticTimeImage
            
            }
            cell.delegate = self
            cell.toDoItem = event
        
        return cell
        }
    }
    

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // If detail cell, then response nothing
        if(detailRow.contains(indexPath.row)){
            
            // Print Testing //
            
            let selectedCell:DetailCell = tableView.cellForRowAtIndexPath(indexPath)! as! DetailCell
            NSLog(String(selectedCell.mySec))
            
            
            return
        }
        
        let selectedCell:EventCell = tableView.cellForRowAtIndexPath(indexPath)! as! EventCell
        
        if(selectedCell.showedDetail == false){
        
            //Below are adding mew detail cell if possible
            events.insert(Event(name: "DETAILS", timeRemaining: 0.00), atIndex: indexPath.row + 1)
            
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
            // showed detail == true and and is showinhg details //
            

            let toremove = detailRow.indexOf(indexPath.row + 1)
            if(toremove != nil){detailRow.removeAtIndex(toremove!)}
            
            
            // Adjust the indexes about the height
            for(var i = 0; i < detailRow.count; i++){
                if(detailRow[i] > indexPath.row + 1 ){
                    detailRow[i] = detailRow[i] - 1
                }
            }
            
            
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
        
        
        
        /* NEED CODES HERE TO HANDLE SITUATION WHERE 
        ITEM IS BEING DELETED WHILE DETAIL CELL IS SHOWING */
        
        
        
        
        /* ENDS HERE */
        
        
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
