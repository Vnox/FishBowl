//
//  EventCell.swift
//  αBaro
//
//  Created by Leon on 12/14/15.
//  Copyright © 2015 Ethereo. All rights reserved.
//

import UIKit
import QuartzCore

protocol TableViewCellDelegate {
    // indicates that the given item has been deleted
    func toDoItemDeleted(todoItem: Event)
}

class EventCell: UITableViewCell {

    @IBOutlet weak var EventName: UILabel!
    @IBOutlet weak var hoursLeft: UILabel!
    @IBOutlet weak var urgentImg: UIImageView!
    @IBOutlet weak var bkgTrans: UIImageView!
    @IBOutlet weak var ballIcon: UILabel!
    @IBOutlet weak var TimerLabel: UILabel!
    
    
    var isDetail = false
    var showedDetail = false
    var recordState = false
    
    var crossLabel: UILabel
    
    var startTime = NSTimeInterval()
    var timer : NSTimer!
    
    //Gesture handler
    var originalCenter = CGPoint()
    var deleteOnDragRelease = false
    var giftOnDragRelease = false
    
    var delegate: TableViewCellDelegate?
    var toDoItem: Event?
    
    required init?(coder aDecoder: NSCoder) {
        
        // utility method for creating the contextual cues
        func createCueLabel() -> UILabel {
            let label = UILabel(frame: CGRect.null)
            label.textColor = UIColor.whiteColor()
            label.font = UIFont.boldSystemFontOfSize(32.0)
            label.backgroundColor = UIColor.clearColor()
            return label
        }
        
        // tick and cross labels for context cues
        
        crossLabel = createCueLabel()
        crossLabel.text = "\u{2717}"
        crossLabel.textAlignment = .Left
        

        super.init(coder: aDecoder)

        
        self.frame = CGRect(x: contentView.frame.origin.x, y: contentView.frame.origin.y, width: contentView.frame.width + 100, height: contentView.frame.height)
        self.deleteOnDragRelease = false
        
        
        addSubview(crossLabel)
        // remove the default blue highlight for selected cells
        selectionStyle = .None
        
        // Initialization code
        let recognizer = UIPanGestureRecognizer(target: self, action: "handlePan:")
        recognizer.delegate = self
        addGestureRecognizer(recognizer)

    }
    

    let kUICuesMargin: CGFloat = 10.0, kUICuesWidth: CGFloat = 50.0
    
    override func layoutSubviews() {
        super.layoutSubviews()
           crossLabel.frame = CGRect(x: bounds.size.width + kUICuesMargin, y: 0,
            width: kUICuesWidth, height: bounds.size.height)
        if(self.recordState){self.bkgTrans.image = UIImage(named: "RecingBkg")}
        else{self.bkgTrans.image = UIImage(named: "CellBkg")}
        
    }
    
    override func awakeFromNib() {
        self.TimerLabel.alpha = 0.0
        //self.bkgTrans.image = UIImage(named: "CellBkg")
    }
    

    
    // Leon -- handle the swipe gesture
    func handlePan(recognizer: UIPanGestureRecognizer) {
        
        if recognizer.state == .Began {
            // save center
            originalCenter = center

        }
        
        if recognizer.state == .Changed {
            let translation = recognizer.translationInView(self)
            center = CGPointMake(originalCenter.x + translation.x, originalCenter.y)
            // has the user dragged the item far enough to initiate a delete/complete?
            deleteOnDragRelease = frame.origin.x < -frame.size.width / 4.0
            giftOnDragRelease = frame.origin.x > frame.size.width / 4.0
            
            // fade the contextual clues
            let cueAlpha = fabs(frame.origin.x) / (frame.size.width / 2.0)

            crossLabel.alpha = cueAlpha
            // indicate when the user has pulled the item far enough to invoke the given action
            
            // configurate the background
            if(deleteOnDragRelease){bkgTrans.image = UIImage(named: "DD")}
                
            else if(giftOnDragRelease){
        
                if(recordState == false){bkgTrans.image = UIImage(named: "RecordBkg")}
                if(recordState == true){bkgTrans.image = UIImage(named: "PauseBkg")}
                
            }
                
            else{
                bkgTrans.image = recordState ? UIImage(named: "RecingBkg") : UIImage(named: "CellBkg")
            }

            EventName.alpha = deleteOnDragRelease||giftOnDragRelease ? 0.0 : urgentImg.alpha
            hoursLeft.alpha = giftOnDragRelease ? 0.0 : urgentImg.alpha
            urgentImg.alpha = deleteOnDragRelease||giftOnDragRelease ? 0.0 : urgentImg.alpha
            ballIcon.alpha = deleteOnDragRelease||giftOnDragRelease ? 0.0 : urgentImg.alpha
            
            if(deleteOnDragRelease||giftOnDragRelease){
                
                EventName.alpha = 0.0
                hoursLeft.alpha = 0.0
                urgentImg.alpha = 0.0
                ballIcon.alpha = 0.0
                
            }else{
                
                self.hoursLeft.alpha = self.recordState ? 0.0 : 1.0
                self.EventName.alpha = self.recordState ? 0.0 : 1.0
                self.urgentImg.alpha = self.recordState ? 0.0 : 1.0
                self.ballIcon.alpha = self.recordState ? 0.0 : 1.0
                
            }

            
        }
        
        if recognizer.state == .Ended {
        
            // the frame this cell had before user dragged it
            let originalFrame = CGRect(x: 0, y: frame.origin.y,
                width: bounds.size.width, height: bounds.size.height)
            
            if !deleteOnDragRelease {
                // set back location with animation
                UIView.animateWithDuration(0.4, animations: {
                    self.frame = originalFrame
                })
            }
            
            if deleteOnDragRelease {
                if delegate != nil && toDoItem != nil {
                    // notify the delegate that this item should be delete
                    delegate!.toDoItemDeleted(toDoItem!)
                }
            }
            else if giftOnDragRelease{

                self.hoursLeft.alpha = self.recordState ? 0.0 : 1.0
                self.EventName.alpha = self.recordState ? 0.0 : 1.0
                self.urgentImg.alpha = self.recordState ? 0.0 : 1.0
                self.ballIcon.alpha = self.recordState ? 0.0 : 1.0
                
                if(recordState == true){
                    recordState = false
                    self.bkgTrans.image = UIImage(named: "CellBkg")
                    self.TimerLabel.alpha = 0.0
                    NSLog("NO")
                    //COPIED
                    self.hoursLeft.alpha = self.recordState ? 0.0 : 1.0
                    self.EventName.alpha = self.recordState ? 0.0 : 1.0
                    self.urgentImg.alpha = self.recordState ? 0.0 : 1.0
                    self.ballIcon.alpha = self.recordState ? 0.0 : 1.0
                    return

                }
                else{
                    recordState = true
                    self.bkgTrans.image = UIImage(named: "RecingBkg")}
                    self.TimerLabel.alpha = 1.0
                    let aSelector : Selector = "updateTime"
                    timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
                    startTime = NSDate.timeIntervalSinceReferenceDate()
                    //NSLog("YES")
            }
            self.hoursLeft.alpha = self.recordState ? 0.0 : 1.0
            self.EventName.alpha = self.recordState ? 0.0 : 1.0
            self.urgentImg.alpha = self.recordState ? 0.0 : 1.0
            self.ballIcon.alpha = self.recordState ? 0.0 : 1.0
            
        }
    }
    
    
    
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translationInView(superview!)
            if fabs(translation.x) > fabs(translation.y) {
                return true
            }
            return false
        }
        return false
    }
    
    func updateTime() {
        
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        
        //Find the difference between current time and start time.
        
        var elapsedTime: NSTimeInterval = currentTime - startTime
        
        //calculate the minutes in elapsed time.
        
        let minutes = UInt8(elapsedTime / 60.0)
        
        elapsedTime -= (NSTimeInterval(minutes) * 60)
        
        //calculate the seconds in elapsed time.
        
        let seconds = UInt8(elapsedTime)
        
        elapsedTime -= NSTimeInterval(seconds)
        
        //find out the fraction of milliseconds to be displayed.
        
        let fraction = UInt8(elapsedTime * 100)
        
        //add the leading zero for minutes, seconds and millseconds and store them as string constants
        
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        //let strFraction = String(format: "%02d", fraction)
        
        //concatenate minuets, seconds and milliseconds as assign it to the UILabel
        
        TimerLabel.text = "\(strMinutes):\(strSeconds)"
        
    }
    


}
