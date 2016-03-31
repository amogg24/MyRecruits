//
//  databaseViewController.swift
//  MyRecruits
//
//  Created by Andrew Mogg on 12/4/15.
//  Copyright © 2015 Andrew Mogg. All rights reserved.
//

import UIKit

class DatabaseViewController: UIViewController {
    @IBOutlet var athleteNameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    /*
    ------------------------
    MARK: - IBAction Methods
    ------------------------
    */
    @IBAction func keyboardDone(sender: UITextField) {
        
        // Deactivate the Address Text Field object and remove the Keyboard
        sender.resignFirstResponder()
    }
    
    @IBAction func backgroundTouch(sender: UIControl) {
        
        // Deactivate the Address Text Field object and remove the Keyboard
        athleteNameTextField.resignFirstResponder()
        
    }
    @IBAction func searchButtonTapped(sender: UIButton) {
        // If no name is entered, alert the user
        if athleteNameTextField.text == "" {
            let alertController = UIAlertController(title: "Selection Missing!",
            message: "Please enter all fields!!",
            preferredStyle: UIAlertControllerStyle.Alert)

            // Create a UIAlertAction object and add it to the alert controller
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
    
            // Present the alert controller by calling the presentViewController method
            presentViewController(alertController, animated: true, completion: nil)
            
            return
        }
        performSegueWithIdentifier("showDatabase", sender: self)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if segue.identifier == "showDatabase" {
            
            // Obtain the object reference of the destination view controller
            let databaseWebViewController: DatabaseWebViewController = segue.destinationViewController as! DatabaseWebViewController
            
            //Pass the data object to the destination view controller object
            databaseWebViewController.searchName = athleteNameTextField.text!
            athleteNameTextField!.text = ""
        }
    }
}
