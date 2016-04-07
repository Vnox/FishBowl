//
//  shareViewController.swift
//  αBaro
//
//  Created by Leon on 2/24/16.
//  Copyright © 2016 Ethereo. All rights reserved.
//

import UIKit
import Charts

class shareViewController: UIViewController {
    
    @IBOutlet weak var needLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
  
    @IBOutlet weak var myButton: UIButton!
    
    @IBOutlet weak var statsView: LineChartView!
   
    
    // simulate model //
    //在这里加入百分比//
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let months = ["Day 1", "Day 2", "Day 3", "Day 4", "Day 5", "Day 6", "Day 7", "Day 8", "Day 9", "Day 10", "Day 11", "Day 12", "Day 13", "Day 14", "Day 15", "Day 16", "Day 17", "Day 18", "Day 19", "Day 20", "Day 21"]
//        let unitsSold = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 11.0, 12.0, 13.0, 14.0, 15.0, 16.0, 17.0,]
        
        
        let months = ["Day 1", "Day 2", "Day 3", "Day 4", "Day 5"]
        let unitsSold = [1.0, 2.0, 3.0, 4.0, 5.0]
        
        setChart(months, values: unitsSold)

    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        
        var colors: [UIColor] = []
        
//        for i in 0..<dataPoints.count {
//            let red = Double(arc4random_uniform(256))
//            let green = Double(arc4random_uniform(256))
//            let blue = Double(arc4random_uniform(256))
//            
//            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
//            colors.append(color)
//        }
        
//        pieChartDataSet.colors = colors
//        
    
        
        
        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "Units Sold")
        lineChartDataSet.setColor(UIColor.whiteColor())
        lineChartDataSet.lineWidth = 3
        lineChartDataSet.valueTextColor = UIColor.whiteColor()
        //lineChartDataSet.drawCirclesEnabled = false
        lineChartDataSet.drawCircleHoleEnabled = false
        lineChartDataSet.circleColors = [UIColor.whiteColor()]
        
        let lineChartData = LineChartData(xVals: dataPoints, dataSet: lineChartDataSet)
        
        
        
        statsView.backgroundColor = UIColor(red: 34, green: 53, blue: 95, alpha: 0.0)
        statsView.gridBackgroundColor = UIColor(red: 34, green: 53, blue: 95, alpha: 0.0)
        statsView.borderColor = UIColor(red: 34, green: 53, blue: 95, alpha: 0.0)
        
        statsView.xAxis.gridAntialiasEnabled = false
        statsView.descriptionTextColor = UIColor.whiteColor()
        statsView.infoTextColor = UIColor.whiteColor()
        //statsView.leftAxis.zeroLineColor = UIColor.whiteColor()
        //statsView.leftAxis.axisLineColor = UIColor.whiteColor()
        statsView.xAxis.labelTextColor = UIColor.whiteColor()
        //statsView.leftAxis.labelTextColor = UIColor.whiteColor()
        statsView.legend.textColor = UIColor.whiteColor()
        
        statsView.leftAxis.drawLabelsEnabled = false
        statsView.rightAxis.drawLabelsEnabled = false
        statsView.leftAxis.drawAxisLineEnabled = false
        statsView.rightAxis.drawAxisLineEnabled = false
        
        
        statsView.xAxis.drawLabelsEnabled = false
        statsView.xAxis.drawAxisLineEnabled = false
        statsView.leftAxis.drawGridLinesEnabled = false
        statsView.rightAxis.drawGridLinesEnabled = false
        statsView.xAxis.drawGridLinesEnabled = false

        
        statsView.data = lineChartData
        
    }

    
    
    @IBAction func backTouched(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
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
