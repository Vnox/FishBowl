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

class MainViewController: UIViewController {
    
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var baseImage: UIButton!
    @IBOutlet weak var percentLAbel: UILabel!
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var bkgImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var monthTag: UILabel!
    @IBOutlet weak var dayTag: UILabel!
    @IBOutlet weak var ringImage: UIImageView!
    @IBOutlet weak var Dimmer: UIImageView!
    @IBOutlet weak var NiceTalk: UILabel!
    @IBOutlet weak var cloud1: UIImageView!
    @IBOutlet weak var cloud2: UIImageView!

    
    var flipped = false
    var first = true
    
    

    var event = [NSManagedObject]()
    
    var myPercent = 0
    var percentage = 42
    var animated = false
    
    @IBOutlet weak var R2Image: UIButton!

    
    
    override func viewDidLoad() {
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        swipeGesture.numberOfTouchesRequired = 1
        swipeGesture.direction = .Up
        view.addGestureRecognizer(swipeGesture)

        
        NSThread.sleepForTimeInterval(1.0)
        
        super.viewDidLoad()
        
        
        

        
        // bkg calibrate
        self.bkgImage.frame.size.height = view.frame.size.height + 3.0
        self.bkgImage.frame.size.width = view.frame.size.width + 2.0
        self.bkgImage.center.y -= 2
        
        //Set baseImage
        let baseImageString = String(self.percentage / 10 * 10)
        var tempString = "level"
        tempString = tempString.stringByAppendingString(baseImageString)

        NSLog(tempString)
        
        self.timeLabel.center.y -= 50
        self.monthTag.center.y -= 50
        self.dayTag.center.y -= 50
        self.greetingLabel.center.y -= 50
        
        self.ringImage.center.y += 30
        self.baseImage.center.y += 30
        
        self.ringImage.alpha = 0.0
        self.baseImage.alpha = 0.0
        
        self.R2Image.center.y += 30
        self.R2Image.alpha = 0.0
        
        self.cloud1.alpha -= 1.0
        self.cloud2.alpha -= 1.0
        
        
        


        
        
        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("updateTime"), userInfo: nil, repeats: true)

//        UIView.animateWithDuration(1.0, delay: 0.0, options: [ .Repeat, .Autoreverse ], animations: {
//            self.ringImage.transform = CGAffineTransformMakeRotation(0.1);
//            }, completion: nil)

        
        
        myPercent = 0
        self.first = true
        
        NSTimer.scheduledTimerWithTimeInterval(0.03, target: self, selector: Selector("updatePercent"), userInfo: nil, repeats: true)
        
        UIView.animateWithDuration(1.0, delay: 1.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: [] , animations: {
            
            self.timeLabel.center.y += 50
            self.monthTag.center.y += 50
            self.dayTag.center.y += 50
            self.greetingLabel.center.y += 50
            
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
        
        self.cloud1.center.y -= 15
        self.cloud2.center.x -= 10
        
        var adelay = 0.0
        
        if(first){
            adelay += 1.5
            first = false
        }
        
        
        UIView.animateWithDuration(2.0, delay: 3.0,  options: [ .CurveEaseInOut, .Repeat,], animations: {
            self.arrowImage.center.y -= 10
            self.arrowImage.alpha -= 1.0
            }, completion:nil )
        
        UIView.animateWithDuration(1.5, delay: adelay, options: [ .CurveEaseIn, ], animations: {
            self.cloud1.alpha += 1.0
            self.cloud2.alpha += 1.0
            }, completion: nil)
        
        UIView.animateWithDuration(2.0, delay: adelay, options: [ .CurveEaseIn, .Autoreverse, .Repeat ], animations: {
            self.cloud1.center.y += 15
            self.cloud2.center.x += 10
            }, completion: nil)
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.cloud1.alpha -= 1.0
        self.cloud2.alpha -= 1.0
    }
    
    func updatePercent() {
            self.percentLAbel.text = String.localizedStringWithFormat("%d%%", myPercent)
        if(self.myPercent < self.percentage){
            myPercent++}
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
        
        if(minutes <= 9){
            self.timeLabel.text = String.localizedStringWithFormat("It's %d:0%d, ",hour,minutes)
        }else{
            self.timeLabel.text = String.localizedStringWithFormat("It's %d:%d, ",hour,minutes)
        }
        
        if( hour > 21 && hour <= 24 ){
            self.timeLabel.text = self.timeLabel.text!.stringByAppendingString(" Good night : )")
        }
        if( hour > 13 && hour <= 17 ){
            self.timeLabel.text = self.timeLabel.text!.stringByAppendingString(" Have a wonderful afternoon.")
        }
        if( hour > 17 && hour <= 21 ){
            self.timeLabel.text = self.timeLabel.text!.stringByAppendingString(" Good evening.")
        }
        if( hour > 0 && hour <= 5){
            self.timeLabel.text = self.timeLabel.text!.stringByAppendingString(" I'm so sleepy right now.")
        }
        if( hour > 5 && hour <= 9){
            self.timeLabel.text = self.timeLabel.text!.stringByAppendingString(" Good morning, Yay!")
        }
        if( hour > 9 && hour <= 13){
            self.timeLabel.text = self.timeLabel.text!.stringByAppendingString(" Boring work, huh?")
        }
        
        
    
        
        self.monthTag.text = String.localizedStringWithFormat(exchangeMonth(inDay: month))
        self.dayTag.text = String.localizedStringWithFormat("%dth",day)


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
            self.cloud1.alpha -= 1.0
            self.cloud2.alpha -= 1.0
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
                self.cloud1.alpha += 1.0
                self.cloud2.alpha += 1.0
                }, completion:nil )
            
            flipped = false
        
        
        
        }

        
        
        
    }
    
    
    
    @IBAction func createPushed(sender: UIButton) {
        
        //Below are alert view. Need Customization
        //blur
//        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        
//        blurEffectView.frame = self.view.bounds
//        blurEffectView.alpha = 0.0
        
//        let alert = UIAlertController(title: "New Name",
//            message: "Add a new name",
//            preferredStyle: .Alert)
//        
//        alert.view.backgroundColor = UIColor.blackColor()
////        
//        let saveAction = UIAlertAction(title: "Save",
//            style: .Default,
//            handler: { (action:UIAlertAction) -> Void in
//                
//                let textField = alert.textFields!.first
//                self.saveName(textField!.text!)
//        })
//
//        let cancelAction = UIAlertAction(title: "Cancel",
//            style: .Default) { (action: UIAlertAction) -> Void in
//        }
//        
//        alert.addTextFieldWithConfigurationHandler {
//            (textField: UITextField) -> Void in
//        }
//        
//        alert.addAction(saveAction)
//        alert.addAction(cancelAction)
//        
//        presentViewController(alert,
//            animated: true,
//            completion: nil)
//
        
        
        let customIcon = UIImage(named: "lightbulb")
        let alertview = JSSAlertView().show(self, title: "New Event", text: "This is still under construction. Don't press me yet : )", buttonText: "Cancel",cancelButtonText: "Confirm", color: UIColorFromHex(0x496FBE, alpha: 1), iconImage: customIcon)
        alertview.setTitleFont("AvenirNext-Regular")
        alertview.setTextFont("AvenirNext-Regular")
        alertview.setButtonFont("AvenirNext-Regular")
        alertview.setTextTheme(.Light)
        alertview.addAction(bloodyHell)
        
    }

    
    func bloodyHell(){
        
        print("anbla")
        
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
        
        let itemsToShare : NSArray = ["https://itunes.apple.com/us/app/id961390574",snapshot(),"the best app ever"]
        let shareBar : UIActivityViewController = UIActivityViewController(activityItems: itemsToShare as [AnyObject], applicationActivities: nil);
        shareBar.excludedActivityTypes = [];
        self.presentViewController(shareBar, animated: true, completion: nil);
        
    }
    
    func handleSwipes(sender:UISwipeGestureRecognizer){
        
        let myBoard = UIStoryboard(name: "Main", bundle: nil)
        let theView = myBoard.instantiateViewControllerWithIdentifier("complexView")
        theView.modalTransitionStyle = .CoverVertical
        theView.view.backgroundColor = UIColor.clearColor()
        theView.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        //self.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        presentViewController(theView, animated: true, completion: nil)
        
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

