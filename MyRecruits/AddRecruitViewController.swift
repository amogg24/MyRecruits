//
//  AddRecruitViewController.swift
//  MyRecruits
//
//  Created by Andrew Mogg on 11/29/15.
//  Copyright © 2015 Andrew Mogg. All rights reserved.
//

import UIKit
import Photos
import MessageUI

class AddRecruitViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIScrollViewDelegate, UITextFieldDelegate  {

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
    
    let APPLE_BLUE = UIColor(red: 14.0/255.0, green: 122.0/255.0, blue: 254.0/255.0, alpha: 1.0)

    // Object reference pointing to the active UITextField object
    var activeTextField: UITextField?

    //Used to determine picker view index
    var position = ""
    var pickerData: [String] = [String]()
    var imagePicker: UIImagePickerController!
    var lastName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerData = ["C", "1B", "2B", "3B", "SS", "LF", "CF", "RF", "RHP", "LHP"]
        positionPickerView.selectRow(4, inComponent: 0, animated: true)
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

    /*
     * When saving an image, it rotates 90 degrees. This is a helper to maintain its size and keep its normal 
     * rotation.
     */
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
    
    //Stores the selected row
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        position = pickerData[row]
    }
    
    //Sets the color of the text
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = pickerData[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 15.0)!,NSForegroundColorAttributeName:APPLE_BLUE])
        return myTitle
    }
    
    //Registers the background touch
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
}
