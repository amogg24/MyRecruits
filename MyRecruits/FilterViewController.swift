//
//  FilterViewController.swift
//  MyRecruits
//
//  Created by Andrew Mogg on 12/8/15.
//  Copyright © 2015 Andrew Mogg. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {
    var pickerData: [String] = [String]()
    var position = ""
    let APPLE_BLUE = UIColor(red: 14.0/255.0, green: 122.0/255.0, blue: 254.0/255.0, alpha: 1.0)


    @IBOutlet var filterPickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerData = ["None", "Commitment", "C", "1B", "2B", "3B", "SS", "LF", "CF", "RF", "RHP", "LHP"]

        filterPickerView.selectRow((pickerData.count / 2), inComponent: 0, animated: true)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    //Store the filter choice
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        position = pickerData[row]
    }
    
    //Set the color
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = pickerData[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 15.0)!,NSForegroundColorAttributeName:APPLE_BLUE])
        return myTitle
    }
}
