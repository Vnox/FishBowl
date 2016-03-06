//
//  File.swift
//  αBaro
//
//  Created by Situo Meng on 10/11/15.
//  Copyright (c) 2015 Ethereo. All rights reserved.
//

import Foundation

class Event : NSObject{
    
    var name = ""
    var dueDate = NSDate()
    var timeRemaining = 0.0
    var priority = false
    var tagColor = 3
    var calculatedResult = 0.00
    var showedDetail = false
    
    init(name: String, timeRemaining: Double) {
        
        self.name = name
        self.timeRemaining = timeRemaining
        
    }

    
    init(name: String, timeRemaining: Double, tagColor: Int) {
        
        self.name = name
        self.timeRemaining = timeRemaining
        self.tagColor = tagColor
        
    }
    

    
    init(name: String, timeRemaining: Double, tagColor: Int, showedDetail:Bool) {
        
        self.name = name
        self.timeRemaining = timeRemaining
        self.tagColor = tagColor
        self.showedDetail = showedDetail
        
    }
    



    
    func getName() -> String {
        
        return self.name
        
    }
    
    func getDueDate() -> NSDate{
        
        return self.dueDate
        
    }
    
    func getTimeRemaining() -> Double {
        
        return self.timeRemaining
        
    }
    
    func getPriority() -> Bool {
        
        return self.priority
        
    }
    
    func getCalculatedResult() -> Double{
        
        return self.calculatedResult
        
    }
    
    func changeName(newName:String) {
        
        self.name = newName
        
    }
    
    func changeDueDate(newDueDate:NSDate) {
        
        self.dueDate = newDueDate
        
    }
    
    func changeTimeRemaining(newTimeRemaining:Double) {
        
        self.timeRemaining = newTimeRemaining
        
    }
    
    func changePriority(newPriority:Bool) {
     
        self.priority = newPriority
        
    }
    
    func changeCalculatedResult(newResult:Double) {
        
        self.calculatedResult = newResult
        
    }

    
    func getLocalTime() -> NSDate{
        
        let date = NSDate();
        let dateFormatter = NSDateFormatter()
        //To prevent displaying either date or time, set the desired style to NoStyle.
        dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle //Set time style
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle //Set date style
        dateFormatter.timeZone = NSTimeZone()
        let localDate = dateFormatter.stringFromDate(date)
        let newDate = dateFormatter.dateFromString(localDate)
        
        return newDate!
        
    }
    
}
