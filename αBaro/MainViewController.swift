//
//  MainViewController.swift
//  LifeBaro
//
//  Created by Leon on 10/13/15.
//  Copyright © 2015 EthereoStudio. All rights reserved.
//

import UIKit
import CoreData
import Social

var sound = true

class MainViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var baseImage: UIButton!
    @IBOutlet weak var percentLAbel: UILabel!
    @IBOutlet weak var bkgImage: UIImageView!
    @IBOutlet weak var ringImage: UIImageView!
    @IBOutlet weak var Dimmer: UIImageView!
    @IBOutlet weak var NiceTalk: UILabel!
    @IBOutlet weak var R2Image: UIButton!
    
    
    
    var flipped = false
    var first = true
    var theView = UIViewController!()
    
    
    
    var event = [NSManagedObject]()
    
    var myPercent = 0
    var percentage = 42
    var animated = false
    
    // Animation related stuff
    let progressIndicatorView = leonLoaderView(frame: CGRectZero)
    

    
    
    override func viewDidLoad() {
        
        progressIndicatorView.frame = CGRectMake(0, 0, 100, 100)
        //self.bkgImage.addSubview(progressIndicatorView)
        
        progressIndicatorView.center.y = self.R2Image.center.y
        progressIndicatorView.center.x = self.view.center.x
        
        
        //progressIndicatorView.autoresizingMask = self.view.FlexibleWidth | .FlexibleHeight
        
        self.view.layer.cornerRadius = 7
        self.view.clipsToBounds = true
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        swipeGesture.numberOfTouchesRequired = 1
        swipeGesture.direction = .Up
        view.addGestureRecognizer(swipeGesture)

        
        NSThread.sleepForTimeInterval(1.0)
        // get todayWidget shared info path
        let sharedDefaults = NSUserDefaults(suiteName: "group.com.ethereo.lifebaro")
        
        super.viewDidLoad()
        
        
        

        
        // bkg calibrate
        self.bkgImage.frame.size.height = view.frame.size.height + 3.0
        self.bkgImage.frame.size.width = view.frame.size.width + 2.0
        self.bkgImage.center.y -= 2
        
        //Set baseImage
        let baseImageString = String(self.percentage / 10 * 10)
        var tempString = "level"
        tempString = tempString.stringByAppendingString(baseImageString)

        //NSLog(tempString)
        
        
        self.ringImage.center.y += 30
        self.baseImage.center.y += 30
        
        self.ringImage.alpha = 0.0
        self.baseImage.alpha = 0.0
        
        self.R2Image.center.y += 30
        self.R2Image.alpha = 0.0

        
        
        //print(event.count)
        
        // get number of tasks
        sharedDefaults?.setObject("\(event.count)", forKey: "StringKey")
        sharedDefaults?.synchronize()
        
        
        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("updateTime"), userInfo: nil, repeats: true)

        myPercent = 0
        self.first = true
        
        NSTimer.scheduledTimerWithTimeInterval(0.03, target: self, selector: Selector("updatePercent"), userInfo: nil, repeats: true)
        
        UIView.animateWithDuration(1.0, delay: 1.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: [] , animations: {
            
            
            self.ringImage.center.y -= 30
            self.baseImage.center.y -= 30
            
            self.ringImage.alpha += 1.0
            self.baseImage.alpha += 1.0
            
            
            
            }, completion: nil)
        

        
        UIView.animateWithDuration(1.0, delay: 1.0, options: [ .CurveEaseIn ], animations: {
                self.Dimmer.alpha -= 0.80
            }, completion: nil)
        
        
        
        UIView.animateWithDuration(1.0, delay: 1.4, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0,  options: [ .CurveEaseInOut ], animations: {
            
            self.R2Image.center.y -= 30
            self.R2Image.alpha += 1.0
            
            }, completion:nil )
        
        
        
    
        
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Hide the status bar
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    

    
    override func viewDidAppear(animated: Bool) {
        

        
        var adelay = 0.0
        
        if(first){
            adelay += 1.5
            first = false
        }
        
        
        UIView.animateWithDuration(2.0, delay: 3.0,  options: [ .CurveEaseInOut, .Repeat,], animations: {
            self.arrowImage.center.y -= 10
            self.arrowImage.alpha -= 1.0
            }, completion:nil )
        

    }
    
    override func viewDidDisappear(animated: Bool) {

    }
    
    func updatePercent() {
            self.percentLAbel.text = String.localizedStringWithFormat("%d", myPercent)
        if(self.myPercent < self.percentage){
            myPercent++}
        progressIndicatorView.progress = CGFloat(Double(myPercent)/100.0)
    }
    

    
    
    func updateTime() {
        
        // Should be handled by Josh in CoreData
        
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([ .Hour , .Minute, .Month, .Day], fromDate: date)
        let hour = components.hour
        let minutes = components.minute
        let day = components.day
        let month = components.month
//        
//        if(minutes <= 9){
//            self.timeLabel.text = String.localizedStringWithFormat("It's %d:0%d, ",hour,minutes)
//        }else{
//            self.timeLabel.text = String.localizedStringWithFormat("It's %d:%d, ",hour,minutes)
//        }
//        
//        if( hour > 21 && hour <= 24 ){
//            self.timeLabel.text = self.timeLabel.text!.stringByAppendingString(" Good night : )")
//        }
//        if( hour > 13 && hour <= 17 ){
//            self.timeLabel.text = self.timeLabel.text!.stringByAppendingString(" Have a wonderful afternoon.")
//        }
//        if( hour > 17 && hour <= 21 ){
//            self.timeLabel.text = self.timeLabel.text!.stringByAppendingString(" Good evening.")
//        }
//        if( hour > 0 && hour <= 5){
//            self.timeLabel.text = self.timeLabel.text!.stringByAppendingString(" I'm so sleepy right now.")
//        }
//        if( hour > 5 && hour <= 9){
//            self.timeLabel.text = self.timeLabel.text!.stringByAppendingString(" Good morning, Yay!")
//        }
//        if( hour > 9 && hour <= 13){
//            self.timeLabel.text = self.timeLabel.text!.stringByAppendingString(" Boring work, huh?")
//        }
//        
//        
//    
        
//        self.monthTag.text = String.localizedStringWithFormat(exchangeMonth(inDay: month))
//        self.dayTag.text = String.localizedStringWithFormat("%dth",day)
//

    }
    
    // Stupid helper method to determine month
    func exchangeMonth(inDay inDay: Int) -> String {
        switch inDay {
            
        case 1: return "Jan"
        case 2: return "Feb"
        case 3: return "Mar"
        case 4: return "Apr"
        case 5: return "May"
        case 6: return "Jun"
        case 7: return "Jul"
        case 8: return "Aug"
        case 9: return "Sep"
        case 10: return "Oct"
        case 11: return "Nov"
        case 12: return "Dec"
            
        default: return "N/A"
            
        }
        
    
    }
    
    @IBAction func testButton(sender: AnyObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName:"Entity")
        
        do{
            let results =
                try managedContext!.executeFetchRequest(fetchRequest)
            event = results as! [NSManagedObject]
            print(results)
        } catch let error as NSError {
            print("could not fetch \(error), \(error.userInfo)")
        }
        
        
    }
    
    @IBAction func BallHited(sender: AnyObject) {
        
        
        if(flipped == false){
        
        UIView.animateWithDuration(0.125, delay: 0.0,  options: [ .CurveEaseInOut ], animations: {
            self.ringImage.transform = CGAffineTransformMakeScale(1.05, 1.05)
            }, completion:nil )
        UIView.animateWithDuration(0.125, delay: 0.125,  options: [ .CurveEaseInOut ], animations: {
            self.ringImage.transform = CGAffineTransformMakeScale(0.99, 0.99)
            }, completion:nil )
        
        UIView.animateWithDuration(0.25, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.9 ,  options: [ .CurveEaseInOut ], animations: {
            self.baseImage.setBackgroundImage(UIImage(named: "DefaultBase"), forState: .Normal)
            self.baseImage.transform = CGAffineTransformMakeScale(-1, 1)
            self.NiceTalk.transform = CGAffineTransformMakeScale(1, 1)
            self.NiceTalk.alpha += 1.0
            }, completion:nil )
            
            flipped = true
            
            
            
        }else{
            
            UIView.animateWithDuration(0.125, delay: 0.0,   options: [ .CurveEaseInOut ], animations: {
                self.ringImage.transform = CGAffineTransformMakeScale(1.05, 1.05)
                }, completion:nil )
            UIView.animateWithDuration(0.125, delay: 0.125,  options: [ .CurveEaseInOut ], animations: {
                self.ringImage.transform = CGAffineTransformMakeScale(0.99, 0.99)
                }, completion:nil )
            
            UIView.animateWithDuration(0.25, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.9 , options: [ .CurveEaseInOut ] , animations: {
                self.baseImage.setBackgroundImage(UIImage(named: "level40"), forState: .Normal)
                self.baseImage.transform = CGAffineTransformMakeScale(1, 1)
                self.NiceTalk.transform = CGAffineTransformMakeScale(-1, 1)
                self.NiceTalk.alpha -= 1.0
                }, completion:nil )
            
            flipped = false
        
        
        
        }

        
        
        
    }
    
    
    
    @IBAction func createPushed(sender: UIButton) {
        //Hello from the other side
   
    }


    
    func saveName(name: String) {
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let entity =  NSEntityDescription.entityForName("Entity",inManagedObjectContext:managedContext!)
        
        let person = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext: managedContext)
        
        //3
        person.setValue(name, forKey: "name")
        
        //4
        do {
            try managedContext!.save()
            print("saved!")
            //5
            event.append(person)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    
    // @IBAction func shareButton
    
    func snapshot() -> UIImage{
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, false, UIScreen.mainScreen().scale)
        
        self.view.drawViewHierarchyInRect(self.view.bounds, afterScreenUpdates: true)
        
        let screenShotImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return screenShotImg
    }
    
    @IBAction func shareButton(sender: AnyObject) {
        
        
        MonkeyKing.registerAccount(.WeChat(appID: "wx4868b35061f87885", appKey: "64020361b8ec4c99936c0e3999a9f249"))
        
        let shareURL = NSURL(string: "http://www.apple.com/cn/iphone/compare/")!
        
        let info = MonkeyKing.Info(
            title: "iPhone Compare",
            description: "iPhone 机型比较",
            thumbnail: UIImage(named: "rabbit"),
            media: .URL(shareURL)
        )
        
        let sessionMessage = MonkeyKing.Message.WeChat(.Session(info: info))
        
        let weChatSessionActivity = AnyActivity(
            type: "com.nixWork.China.WeChat.Session",
            title: NSLocalizedString("WeChat Session", comment: ""),
            image: UIImage(named: "wechat_session")!,
            message: sessionMessage,
            completionHandler: { success in
                print("Session success: \(success)")
            }
        )
        
        let timelineMessage = MonkeyKing.Message.WeChat(.Timeline(info: info))
        
        let weChatTimelineActivity = AnyActivity(
            type: "com.nixWork.China.WeChat.Timeline",
            title: NSLocalizedString("WeChat Timeline", comment: ""),
            image: UIImage(named: "wechat_timeline")!,
            message: timelineMessage,
            completionHandler: { success in
                print("Timeline success: \(success)")
            }
        )
        
        let activityViewController = UIActivityViewController(activityItems: [shareURL], applicationActivities: [weChatSessionActivity, weChatTimelineActivity])
        
        presentViewController(activityViewController, animated: true, completion: nil)
        
    }
    
    func handleSwipes(sender:UISwipeGestureRecognizer){
        
        let myBoard = UIStoryboard(name: "Main", bundle: nil)
        theView = myBoard.instantiateViewControllerWithIdentifier("complexVC")
        theView.modalTransitionStyle = .CoverVertical
        theView.view.backgroundColor = UIColor.clearColor()
        theView.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        presentViewController(theView, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

  

}
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

