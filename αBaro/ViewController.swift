//
//  ViewController.swift
//  LifeBaro
//
//  Created by Leon on 9/13/15.
//  Copyright (c) 2015 EthereoStudio. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var newResponse = UILabel()
    var coolResponse = UILabel()
    var finalResponse = UILabel()
    var flowBox = UIImageView(image: UIImage(named:"FinalGP"))
    
    
    @IBOutlet var startButton: UIButton!
    @IBOutlet var respondLabel: UILabel!
    @IBOutlet var introButton: UIButton!
    @IBOutlet var baroIcon: UIImageView!
    @IBOutlet var HiIcon: UILabel!
    @IBOutlet weak var coolButton: UIButton!
    
    @IBAction func startApp(sender: UIButton) {
        
        self.startButton.enabled = false
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: [ .CurveEaseIn ], animations: {
            self.clearScreen()
            self.startButton.alpha -= 1.0
            }, completion: nil)
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
            self.performSegueWithIdentifier("mainView", sender: self)
        })
        
        
    }
    
    
    @IBAction func coolPressed(sender: UIButton) {
        
        UIView.animateWithDuration(1.5, delay:0.0,options: [], animations: {
            self.moveUp(offset: 80.0)
            self.view.addSubview(self.coolResponse)
            self.newResponse.center.y -= 80
            self.coolResponse.center.y -= 220
            self.coolResponse.alpha += 1.0
            self.coolButton.alpha -= 1.0
            self.coolButton.enabled = false
            }, completion: nil)
        
        UIView.animateWithDuration(1.5, delay:1.5,options: [], animations: {
            self.moveUp(offset: 80.0)
            self.newResponse.center.y -= 80
            self.coolResponse.center.y -= 80
            self.view.addSubview(self.finalResponse)
            self.finalResponse.center.y -= 240
            self.finalResponse.alpha += 1.0
            }, completion: nil)
        
        UIView.animateWithDuration(1.0, delay:3.0,usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0,options: [], animations: {
            self.view.addSubview(self.flowBox)
            self.flowBox.alpha += 1.0
            self.flowBox.transform = CGAffineTransformMakeScale(110, 110)
            
            }, completion: nil)
        
        UIView.animateWithDuration(1.0, delay: 4.0, options: [ .Repeat, .Autoreverse, .CurveEaseInOut], animations: {
            self.flowBox.center.y += 10
            }, completion: nil)
        
        UIView.animateWithDuration(1.5, delay: 4.0, options: [.CurveEaseInOut], animations: {
            self.startButton.alpha += 1.0
            }, completion: nil)
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(4.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
            self.startButton.enabled = true
            
        })
    }
    
    
    @IBAction func pressedIntroButton(sender: UIButton) {
        UIView.animateWithDuration(1.0, animations: {
            self.introButton.alpha -= 1.0
            self.introButton.enabled = false
            self.respondLabel.alpha += 1.0
            self.moveUp(offset: 40.0)
            
        })
        
        UIView.animateWithDuration(1.5, delay:1.0,options: [], animations: {
            self.moveUp(offset: 80.0)
            }, completion: nil)
        
        UIView.animateWithDuration(1.5, delay:1.0,options: .CurveEaseInOut, animations: {
            self.view.addSubview(self.newResponse)
            self.newResponse.center.y -= 270
            self.newResponse.alpha += 1.0
            }, completion: nil)
        
        UIView.animateWithDuration(1.5, delay:2.9,options: .CurveEaseInOut, animations: {
            self.coolButton.alpha += 1.0
            // self.coolButton.enabled = true
            }, completion: nil)
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2.9 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
            self.coolButton.enabled = true
            
        })
        
        
    }
    
    // Hide the status bar
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        
        // Do any additional setup after loading the view, typically from a nib.
        super.viewDidLoad()
        
        //Animate IconBot
        self.baroIcon.transform = CGAffineTransformMakeRotation(-0.05)
        
        UIView.animateWithDuration(1.0, delay: 0.0, options: [ .Repeat, .Autoreverse, .CurveEaseInOut ], animations: {
            self.baroIcon.transform = CGAffineTransformMakeRotation(0.1)
            }, completion: nil)
        
        // Off stage the start button
        
        self.startButton.alpha = 0.0
        self.startButton.center.x = view.center.x
        self.startButton.center.y = view.center.y + 270
        self.startButton.enabled = false
        
        // Center the labels and images
        flowBox.frame.size.width = 3.0
        flowBox.frame.size.height = 1.75
        flowBox.alpha = 0.0
        
        flowBox.center.x = view.center.x
        flowBox.center.y = view.center.y + 120
        
        
        // Elemnts setups
        coolResponse.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.size.width, height: view.frame.size.height/8)
        coolResponse.center.x = view.center.x
        coolResponse.center.y = view.center.y + 200
        coolResponse.alpha = 0.0
        coolResponse.font = UIFont(name:"Didot-Bold", size: 17.0)
        coolResponse.textColor = UIColor()
        coolResponse.textAlignment = .Center
        coolResponse.text = "That sounds cool !"
        coolResponse.textColor = UIColor(red: 118/255, green: 28/255, blue: 33/255, alpha: 1.0)
        coolResponse.numberOfLines = 1
        
        finalResponse.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.size.width, height: view.frame.size.height/4)
        finalResponse.center.x = view.center.x
        finalResponse.center.y = view.center.y + 200
        finalResponse.alpha = 0.0
        finalResponse.font = UIFont(name:"Didot-Bold", size: 17.0)
        finalResponse.textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        finalResponse.textAlignment = .Center
        finalResponse.text = "Thanks. \n I only need you to provide \n the informations below, \n and I'll do the rest."
        finalResponse.numberOfLines = 4
        
        
        newResponse.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.size.width, height: view.frame.size.height/8)
        newResponse.center.x = view.center.x
        newResponse.center.y = respondLabel.center.y + 200
        newResponse.alpha = 0.0
        newResponse.font = UIFont(name: "Didot-Bold", size: 17.0)
        newResponse.textAlignment = .Center
        newResponse.numberOfLines = 3
        newResponse.textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        newResponse.text = "I'm your personal doctor to examine \n your schedule and provide you \n information about your life."
        
        coolButton.alpha = 0.0
        coolButton.enabled = false
        coolButton.center.x = view.center.x
        coolButton.center.y = view.frame.size.height - 50
        
        
        respondLabel.alpha = 0.0
        respondLabel.center.x = view.center.x
        baroIcon.center.x = view.center.x
        HiIcon.center.x = view.center.x
        introButton.center.x = view.center.x
        HiIcon.center.y += 260
        introButton.center.y = view.frame.size.height - 50
        
        // Other settings (OFF STAGE)
        HiIcon.text = "Hi There.\n I'm BaroBot."
        HiIcon.center.y -= 250
        HiIcon.center.y += view.bounds.height
        baroIcon.center.y -= view.bounds.height
        introButton.alpha = 0.0
        
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        UIView.animateWithDuration(1.5, delay: 0.0, options: .CurveEaseOut,animations: {
            self.baroIcon.center.y += self.view.bounds.height
            }, completion: nil)
        
        UIView.animateWithDuration(1.5, delay: 0.7, options: .CurveEaseOut, animations: {
            self.HiIcon.center.y -= self.view.bounds.height
            }, completion: nil)
        
        UIView.animateWithDuration(1.5, delay: 2.5, options: .CurveEaseOut, animations: {
            self.introButton.alpha += 1.0
            }, completion: nil)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func moveUp(offset offset: CGFloat){
        self.baroIcon.center.y -= offset
        self.HiIcon.center.y -= offset
        self.respondLabel.center.y -= offset
    }
    
    func clearScreen(){
        self.coolResponse.center.y -= 700
        self.newResponse.center.y -= 700
        self.HiIcon.center.y -= 700
        self.introButton.center.y -= 700
        self.baroIcon.center.y -= 700
        self.respondLabel.center.y -= 700
        self.finalResponse.center.y -= 700
        self.flowBox.center.y -= 700
    }
    
    
}

