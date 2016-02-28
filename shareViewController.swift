//
//  shareViewController.swift
//  αBaro
//
//  Created by Leon on 2/24/16.
//  Copyright © 2016 Ethereo. All rights reserved.
//

import UIKit

class shareViewController: UIViewController {
    
    @IBOutlet weak var needLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var myEventsView: UIView!
    @IBOutlet weak var percentDisplayButton: UIButton!
    @IBOutlet weak var myButton: UIButton!
    
    var pressedIt = false

    let progressIndicatorView = leonLoaderView(frame: CGRectZero)
    let colorCircle1 = leonLoaderView(frame: CGRectZero)
    let colorCircle2 = leonLoaderView(frame: CGRectZero)
    let colorCircle3 = leonLoaderView(frame: CGRectZero)
    let colorCircle4 = leonLoaderView(frame: CGRectZero)
    let colorCircle5 = leonLoaderView(frame: CGRectZero)
    let greyCircle = leonLoaderView(frame: CGRectZero)
    
    var myPercent = 0
    var percentage = 42
    
    // simulate model //
    var thing1 = 5
    var thing2 = 15
    var thing3 = 40
    var thing4 = 70
    var thing5 = 100
    var p1 = 0
    var p2 = 0
    var p3 = 0
    var p4 = 0
    var p5 = 0
    
    var t1 : NSTimer!
    var t2 : NSTimer!
    var t3 : NSTimer!
    var t4 : NSTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSLog("VDIDL")
        self.myEventsView.center.y += 400
        self.percentDisplayButton.center.x = self.view.center.x
        self.displayLabel.userInteractionEnabled = false
        
        
        colorCircle1.center = self.percentDisplayButton.center
        colorCircle2.center = self.percentDisplayButton.center
        colorCircle3.center = self.percentDisplayButton.center
        colorCircle4.center = self.percentDisplayButton.center
        colorCircle5.center = self.percentDisplayButton.center
        greyCircle.center = self.percentDisplayButton.center
        
        colorCircle1.circlePathLayer.strokeColor = UIColor.redColor().CGColor
        colorCircle2.circlePathLayer.strokeColor = UIColor.orangeColor().CGColor
        colorCircle3.circlePathLayer.strokeColor = UIColor.yellowColor().CGColor
        colorCircle4.circlePathLayer.strokeColor = UIColor.greenColor().CGColor
        colorCircle5.circlePathLayer.strokeColor = UIColor.cyanColor().CGColor
        greyCircle.circlePathLayer.strokeColor = UIColor.blackColor().CGColor
        
        colorCircle1.circlePathLayer.lineWidth = 20
        colorCircle2.circlePathLayer.lineWidth = 20
        colorCircle3.circlePathLayer.lineWidth = 20
        colorCircle4.circlePathLayer.lineWidth = 20
        colorCircle5.circlePathLayer.lineWidth = 20
        greyCircle.circlePathLayer.lineWidth = 18
        
        colorCircle1.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI_2))
        colorCircle2.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI_2))
        colorCircle3.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI_2))
        colorCircle4.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI_2))
        colorCircle5.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI_2))
        
        progressIndicatorView.frame = CGRectMake(150, 190, 100, 100)
        
        self.view.insertSubview(greyCircle, atIndex: 1)
        self.view.insertSubview(progressIndicatorView, aboveSubview: greyCircle)
        self.view.insertSubview(colorCircle5, aboveSubview: progressIndicatorView)
        self.view.insertSubview(colorCircle4, aboveSubview: colorCircle5)
        self.view.insertSubview(colorCircle3, aboveSubview: colorCircle4)
        self.view.insertSubview(colorCircle2, aboveSubview: colorCircle3)
        self.view.insertSubview(colorCircle1, aboveSubview: colorCircle2)
       
        
        progressIndicatorView.center.x = self.view.center.x
        progressIndicatorView.center.y = self.percentDisplayButton.center.y
        progressIndicatorView.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI_2))
        
        greyCircle.progress = 1
        greyCircle.alpha = 0.25
        
        displayLabel.center.x = self.view.center.x
        displayLabel.center.y = self.percentDisplayButton.center.y
        
        
        self.view.layer.cornerRadius = 7
        self.view.clipsToBounds = true
        
        NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("updatePercent"), userInfo: nil, repeats: true)
        
        
        
        // Do any additional setup after loading the view.
    }

    
    
    @IBOutlet weak var displayLabel: UILabel!
    @IBAction func backTouched(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func displayTouched(sender: UIButton) {
        if(self.pressedIt == false){
            
            if(t2 != nil){
                t2.invalidate()
            }
            
            
            UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: [] , animations: {
                self.myEventsView.center.y -= 400
                self.needLabel.center.y += 400
                self.hourLabel.center.y += 400
                self.myButton.center.y += 400
                }, completion: nil)

            
            self.percentage = 100
            thing1 = 5
            thing2 = 15
            thing3 = 40
            thing4 = 70
            thing5 = 100
            
            t1 = NSTimer.scheduledTimerWithTimeInterval(0.005, target: self, selector: Selector("updatePercent"), userInfo: nil, repeats: true)
            t1.invalidate()
            
            t2 = NSTimer.scheduledTimerWithTimeInterval(0.005, target: self, selector: Selector("updateSections"), userInfo: nil, repeats: true)
            
            
            self.pressedIt = true
            
            return
        }else{
            
            if(t2 != nil){
                t2.invalidate()
            }
            
            UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: [] , animations: {
                self.myEventsView.center.y += 400
                self.needLabel.center.y -= 400
                self.hourLabel.center.y -= 400
                self.myButton.center.y -= 400
                }, completion: nil)
            
            self.percentage = 42
            thing1 = 0
            thing2 = 0
            thing3 = 0
            thing4 = 0
            thing5 = 0
            
            t1 = NSTimer.scheduledTimerWithTimeInterval(0.005, target: self, selector: Selector("updatePercent"), userInfo: nil, repeats: true)
            t1.invalidate()
            
            t2 = NSTimer.scheduledTimerWithTimeInterval(0.005, target: self, selector: Selector("updateSections"), userInfo: nil, repeats: true)
            
            
            self.pressedIt = false
            return

        
        
        }
        
        
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func updatePercent() {
        
        self.displayLabel.text = String.localizedStringWithFormat("%d%%", myPercent)
        if(self.myPercent < self.percentage){
            myPercent++}else if(self.myPercent > self.percentage){
            myPercent--
        }
        progressIndicatorView.progress = CGFloat(Double(myPercent)/100.0)
    }
    
    func updateSections() {
        
        
        if(self.p1 < self.thing1){p1++}else if(self.p1 > self.thing1){p1--}
        colorCircle1.progress = CGFloat(Double(p1)/100.0)
        
        if(self.p2 < self.thing2){p2++}else if(self.p2 > self.thing2){p2--}
        colorCircle2.progress = CGFloat(Double(p2)/100.0)
        
        if(self.p3 < self.thing3){p3++}else if(self.p3 > self.thing3){p3--}
        colorCircle3.progress = CGFloat(Double(p3)/100.0)
        
        if(self.p4 < self.thing4){p4++}else if(self.p4 > self.thing4){p4--}
        colorCircle4.progress = CGFloat(Double(p4)/100.0)
        
        if(self.p5 < self.thing5){p5++}else if(self.p5 > self.thing5){p5--}
        colorCircle5.progress = CGFloat(Double(p5)/100.0)
    
    
    }

    

    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
