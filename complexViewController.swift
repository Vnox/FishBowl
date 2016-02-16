//
//  complexViewController.swift
//  αBaro
//
//  Created by Leon on 12/15/15.
//  Copyright © 2015 Ethereo. All rights reserved.
//

import UIKit

class complexViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clearColor()
        let myBlur = UIBlurEffect(style: .Dark)
        let myEXView = UIVisualEffectView(effect: myBlur)
        myEXView.frame = self.view.bounds
        self.view.insertSubview(myEXView, atIndex: 0)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backbutton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
