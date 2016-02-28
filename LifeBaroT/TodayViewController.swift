//
//  TodayViewController.swift
//  LifeBaroT
//
//  Created by Ethereo PC 1 on 16/2/26.
//  Copyright © 2016年 Ethereo. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var textLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        let sharedDefaults = NSUserDefaults(suiteName: "group.com.ethereo.lifebaro")
        
        // the text label shown info
        textLabel.text = sharedDefaults?.objectForKey("StringKey") as? String
        
        completionHandler(NCUpdateResult.NewData)
    }
    
}
