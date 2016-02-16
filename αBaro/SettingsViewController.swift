//
//  SettingsViewController.swift
//  αBaro
//
//  Created by Situo Meng on 12/15/15.
//  Copyright © 2015 Ethereo. All rights reserved.
//

import UIKit
import MessageUI

class SettingsViewController: UIViewController, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButton(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    @IBAction func soundOn(sender: AnyObject) {
        sound = true
    }
    
    @IBAction func soundOff(sender: AnyObject) {
        sound = false
    }
    
    @IBAction func about(sender: AnyObject) {
        //pending
        
    }
    
    @IBAction func feedBack(sender: AnyObject) {
        //email
        let fbmailCV = FeedbackMFMailComposeViewController()
        if(MFMailComposeViewController.canSendMail()){
        
//            fbmailCV.mailComposeDelegate = self
//            fbmailCV.setToRecipients(["youshua@yahoo.com"])
//            fbmailCV.setSubject("APP Feedback")
//            fbmailCV.setMessageBody("Hi teams\n", isHTML: false)
            
            self.presentViewController(fbmailCV, animated: true, completion: nil)
        
            //fbmailCV.presentViewController(fbmailCV, animated: true, completion: nil)
        }
        else{
            print("FAFA\n")
        }
    }
    
    func FeedbackMFMailComposeViewController() -> MFMailComposeViewController {
        let feedbackM = MFMailComposeViewController()
        feedbackM.mailComposeDelegate = self
        feedbackM.setToRecipients(["youshua@yahoo.com"])
        feedbackM.setSubject("APP Feedback")
        feedbackM.setMessageBody("Hi teams\n", isHTML: false)
        
        return feedbackM
    }
    
    @IBAction func rateOnAppStore(sender: AnyObject) {
        
        let url = NSURL(string: "https://www.baidu.com")
        UIApplication.sharedApplication().openURL(url!)
    }
    
    @IBAction func bugReport(sender: AnyObject) {
        //email
        let brmailCV = BugReportMFMailComposeViewController()
        if(MFMailComposeViewController.canSendMail()){
            
//            fbmailCV.mailComposeDelegate = self
//            fbmailCV.setToRecipients(["youshua@yahoo.com"])
//            fbmailCV.setSubject("APP Feedback")
//            fbmailCV.setMessageBody("Hi teams\n", isHTML: false)
            
            self.presentViewController(brmailCV, animated: true, completion: nil)
            
            //fbmailCV.presentViewController(fbmailCV, animated: true, completion: nil)
        }
        else{
            print("FAFA\n")
        }
    }
    
    func BugReportMFMailComposeViewController() -> MFMailComposeViewController {
        let bugreportM = MFMailComposeViewController()
        bugreportM.mailComposeDelegate = self
        bugreportM.setToRecipients(["youshua@yahoo.com"])
        bugreportM.setSubject("APP Bug Report")
        bugreportM.setMessageBody("Hi teams\n", isHTML: false)
        
        return bugreportM
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        
        switch result.rawValue{
            case MFMailComposeResultCancelled.rawValue:
                print("Mail Cancled\n")
            
            case MFMailComposeResultSaved.rawValue:
                print("Saved\n")
            
            case MFMailComposeResultSent.rawValue:
                print("sent\n")
            
            case MFMailComposeResultFailed.rawValue:
                print("failed\n")
            
            default:
                break
        }
        
        self.dismissViewControllerAnimated(false, completion: nil)
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
