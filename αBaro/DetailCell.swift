//
//  DetailCell.swift
//  αBaro
//
//  Created by Leon on 1/5/16.
//  Copyright © 2016 Ethereo. All rights reserved.
//

import UIKit




class DetailCell: UITableViewCell {
    
    var myHour = 0
    var myMin = 0
    var mySec = 0
    
    var deleteMeAndMyEvent = false
    
    @IBAction func deletePressed(sender: UIButton) {
        self.deleteMeAndMyEvent = true;
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code //
        // Initialize the daysandHours // Maybe in tableview //
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
