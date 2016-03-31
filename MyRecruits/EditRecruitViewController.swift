//
//  EditRecruitViewController.swift
//  MyRecruits
//
//  Created by Andrew Mogg on 12/8/15.
//  Copyright © 2015 Andrew Mogg. All rights reserved.
//

import UIKit

class EditRecruitViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIScrollViewDelegate, UITextFieldDelegate {
    
    var dataObjectPassed = [String]()
    //Entered Recruit Data
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var hometownTextField: UITextField!
    @IBOutlet var highSchoolTextField: UITextField!
    @IBOutlet var phoneNumberTextField: UITextField!
    @IBOutlet var gpaTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var commitmentTextField: UITextField!
    @IBOutlet var bioTextField: UITextField!
    @IBOutlet var positionPickerView: UIPickerView!
    @IBOutlet var yearTextField: UITextField!
    @IBOutlet var pictureImageView: UIImageView!
    @IBOutlet var skillLevelSegmentedControl: UISegmentedControl!
    
    var pickerData: [String] = [String]()
    var position = ""
    var imagePicker: UIImagePickerController!
    let APPLE_BLUE = UIColor(red: 14.0/255.0, green: 122.0/255.0, blue: 254.0/255.0, alpha: 1.0)
    let applicationDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate



    override func viewDidLoad() {
        super.viewDidLoad()

        //Set the objects appriopiately
        nameTextField!.text = dataObjectPassed[0]
        hometownTextField!.text = dataObjectPassed[1]
        commitmentTextField!.text = dataObjectPassed[3]
        yearTextField!.text = dataObjectPassed[2]
        pickerData = ["C", "1B", "2B", "3B", "SS", "LF", "CF", "RF", "RHP", "LHP"]
        positionPickerView.selectRow(checkPosition(pickerData), inComponent: 0, animated: true)
        highSchoolTextField!.text = dataObjectPassed[5]
        gpaTextField!.text = dataObjectPassed[6]
        bioTextField!.text = dataObjectPassed[7]
        skillLevelSegmentedControl.selectedSegmentIndex = Int(dataObjectPassed[9])!
        emailTextField!.text = dataObjectPassed[10]
        phoneNumberTextField!.text = dataObjectPassed[11]
        
        //Load the image
        let fullNameArray = dataObjectPassed[0].componentsSeparatedByString(" ")
        let lastName = fullNameArray[1]
        let nsDocumentDirectory = NSSearchPathDirectory.DocumentDirectory
        let nsUserDomainMask    = NSSearchPathDomainMask.UserDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        
        if paths.count > 0
        {
            let readPath = applicationDelegate.dict_Images.stringByAppendingPathComponent("\(lastName).png")
            let image    = UIImage(contentsOfFile: readPath)
            pictureImageView.image = image
        }

        // Do any additional setup after loading the view.
    }
    //Get the int value of the correct picker view position
    func checkPosition(positions: [String]) -> Int
    {
        var returnValue = Int()
        for (var i = 0; i < positions.count; i++)
        {
            if (positions[i] == "C" && dataObjectPassed[4] == "C")
            {
                returnValue = 0
            }
            if (positions[i] == "1B" && dataObjectPassed[4] == "1B")
            {
                returnValue = 1
            }
            if (positions[i] == "2B" && dataObjectPassed[4] == "2B")
            {
                returnValue = 2
            }
            if (positions[i] == "3B" && dataObjectPassed[4] == "3B")
            {
                returnValue = 3
            }
            if (positions[i] == "SS" && dataObjectPassed[4] == "SS")
            {
                returnValue = 4
            }
            if (positions[i] == "LF" && dataObjectPassed[4] == "LF")
            {
                returnValue = 5
            }
            if (positions[i] == "CF" && dataObjectPassed[4] == "CF")
            {
                returnValue = 6
            }
            if (positions[i] == "RF"  && dataObjectPassed[4] == "RF")
            {
                returnValue = 7
            }
            if (positions[i] == "RHP" && dataObjectPassed[4] == "RHP")
            {
                returnValue = 8
            }
            if (positions[i] == "LHP" && dataObjectPassed[4] == "LHP")
            {
                returnValue = 9
            }
        }
        return returnValue
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        position = pickerData[row]
    }
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = pickerData[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 15.0)!,NSForegroundColorAttributeName:APPLE_BLUE])
        return myTitle
    }
    /////////////////////////////////
    //  Take Profile photo for recruit
    /////////////////////////////////
    @IBAction func takePhotoButtonTapped(sender: UIButton) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        pictureImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        pictureImageView.image = rotateImage(pictureImageView.image!)
        
    }
    func rotateImage(image: UIImage) -> UIImage {
        
        if (image.imageOrientation == UIImageOrientation.Up ) {
            return image
        }
        
        UIGraphicsBeginImageContext(image.size)
        
        image.drawInRect(CGRect(origin: CGPoint.zero, size: image.size))
        let copy = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return copy
    }
    
    // This method is invoked when the user taps the Done key on the keyboard
    @IBAction func keyboardDone(sender: UITextField) {
        
        // Once the text field is no longer the first responder, the keyboard is removed
        sender.resignFirstResponder()
    }
    
    // This method is invoked when the user taps anyone on the background
    @IBAction func backgroundTouch(sender: UIControl) {
        // Deactivate the Address Text Field object and remove the Keyboard
        nameTextField.resignFirstResponder()
        hometownTextField.resignFirstResponder()
        highSchoolTextField.resignFirstResponder()
        phoneNumberTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        bioTextField.resignFirstResponder()
        gpaTextField.resignFirstResponder()
        yearTextField.resignFirstResponder()
        commitmentTextField.resignFirstResponder()
        
        
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
