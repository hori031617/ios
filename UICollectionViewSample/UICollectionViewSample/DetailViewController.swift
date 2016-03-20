//
//  DetailViewController.swift
//  UICollectionViewSample
//
//  Created by 堀 正洋 on 2016/02/11.
//  Copyright © 2016年 masahiro_hori. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var totalMoney: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let userDefault = NSUserDefaults.standardUserDefaults()
        var tmpTotalCount = 0
        
        for day in 0..<365 {
            let tmpSaving = userDefault.objectForKey(String(day))
            if tmpSaving != nil {
                let intSaving = tmpSaving as! Int
                tmpTotalCount += intSaving
            }
        }
        
        let totalCount = NSNumber(integer: tmpTotalCount)
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        
        totalMoney.text = formatter.stringFromNumber(totalCount)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
