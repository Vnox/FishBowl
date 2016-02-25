//
//  shareViewController.swift
//  αBaro
//
//  Created by Leon on 2/24/16.
//  Copyright © 2016 Ethereo. All rights reserved.
//

import UIKit

class shareViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.cornerRadius = 7
        self.view.clipsToBounds = true
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        swipeGesture.numberOfTouchesRequired = 1
        swipeGesture.direction = .Down
        view.addGestureRecognizer(swipeGesture)


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func handleSwipes(sender:UISwipeGestureRecognizer){
        self.dismissViewControllerAnimated(true, completion: nil)
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
