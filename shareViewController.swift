//
//  shareViewController.swift
//  αBaro
//
//  Created by Leon on 2/24/16.
//  Copyright © 2016 Ethereo. All rights reserved.
//

import UIKit

class shareViewController: UIViewController {
    
    @IBOutlet weak var percentDisplay: UILabel!
    
    let progressIndicatorView = leonLoaderView(frame: CGRectZero)
    var myPercent = 0
    var percentage = 75

    @IBOutlet weak var myButton: UIButton!
    
    @IBAction func backTouched(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressIndicatorView.frame = CGRectMake(150, 190, 100, 100)
        self.view.addSubview(progressIndicatorView)
        
        progressIndicatorView.center.x = self.view.center.x
        progressIndicatorView.center.y = self.percentDisplay.center.y
        progressIndicatorView.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI_2))
        
        
        
        self.view.layer.cornerRadius = 7
        self.view.clipsToBounds = true
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        swipeGesture.numberOfTouchesRequired = 1
        swipeGesture.direction = .Down
        view.addGestureRecognizer(swipeGesture)
        
        NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("updatePercent"), userInfo: nil, repeats: true)



        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func updatePercent() {
        
         self.percentDisplay.text = String.localizedStringWithFormat("%d%%", myPercent)
        
        if(self.myPercent < self.percentage){
            myPercent++}
        progressIndicatorView.progress = CGFloat(Double(myPercent)/100.0)
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
