//
//  RecruitInfoViewController.swift
//  MyRecruits
//
//  Created by Andrew Mogg on 11/29/15.
//  Copyright © 2015 Andrew Mogg. All rights reserved.
//

import UIKit
import MessageUI
import Foundation

class RecruitInfoViewController: UIViewController, MFMailComposeViewControllerDelegate {
    //Objects from the storyboard
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var hometownLabel: UILabel!
    @IBOutlet var highSchoolLabel: UILabel!
    @IBOutlet var positionLabel: UILabel!
    @IBOutlet var gpaLabel: UILabel!
    @IBOutlet var commitmentLabel: UILabel!
    @IBOutlet var notesTextView: UITextView!
    @IBOutlet var skillLevelSegmentedControl: UISegmentedControl!
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    let messageComposer = MessageComposer()

    let applicationDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    //Data passed from Table View
    var dataObjectPassed = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set the objects appriopiately
        nameLabel!.text = dataObjectPassed[0]
        hometownLabel!.text = dataObjectPassed[1]
        commitmentLabel!.text = "Commitment: " + dataObjectPassed[3]
        positionLabel!.text = dataObjectPassed[4]
        highSchoolLabel!.text = dataObjectPassed[5] + " HS"
        gpaLabel!.text = "GPA: " + dataObjectPassed[6]
        notesTextView!.text = dataObjectPassed[7]
        skillLevelSegmentedControl.selectedSegmentIndex = Int(dataObjectPassed[9])!
        emailLabel!.text = dataObjectPassed[10]
        phoneLabel!.text = dataObjectPassed[11]
        
        //Set the image
        let fullNameArray = dataObjectPassed[0].componentsSeparatedByString(" ")
        let lastName = fullNameArray[1]
        let nsDocumentDirectory = NSSearchPathDirectory.DocumentDirectory
        let nsUserDomainMask    = NSSearchPathDomainMask.UserDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        
        if paths.count > 0
        {
            let readPath = applicationDelegate.dict_Images.stringByAppendingPathComponent("\(lastName).png")
            let image    = UIImage(contentsOfFile: readPath)
            profileImageView.image = image
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    -----------------------------------
    MARK: - Phone Accessability Methods
    -----------------------------------
    */
    // Create a MessageComposer
    @IBAction func sendTextMessageButtonTapped(sender: UIButton) {

        // Make sure the device can send text messages
        if (messageComposer.canSendText()) {
            // Obtain a configured MFMessageComposeViewController
            let messageComposeVC = messageComposer.configuredMessageComposeViewController(dataObjectPassed[11])
            // Present the configured MFMessageComposeViewController instance
            // Note that the dismissal of the VC will be handled by the messageComposer instance,
            // since it implements the appropriate delegate call-back
            presentViewController(messageComposeVC, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "Cannot Send Text Message",
                message: "Your device is not able to send text messages.",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            // Create a UIAlertAction object and add it to the alert controller
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            
            // Present the alert controller by calling the presentViewController method
            presentViewController(alertController, animated: true, completion: nil)

        }
    }
    
    //Call the Recruit Number
    @IBAction func callButtonTapped(sender: UIButton) {
        let url:NSURL? = NSURL(string: "tel://\(dataObjectPassed[11])")
        UIApplication.sharedApplication().openURL(url!)
    }
    
    //Email the recruit
    @IBAction func sendEmailButtonTapped(sender: AnyObject) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["\(dataObjectPassed[10])"])
        mailComposerVC.setSubject("Sending you an in-app e-mail...")
        mailComposerVC.setMessageBody("We want you to be a student athlete at our school!", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let alertController = UIAlertController(title: "Could Not Send Email",
            message: "Your device could not send e-mail.  Please check e-mail configuration and try again.",
            preferredStyle: UIAlertControllerStyle.Alert)
        
        // Create a UIAlertAction object and add it to the alert controller
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        
        // Present the alert controller by calling the presentViewController method
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    //---------------------------------------------------
    // * MARK: MFMailComposeViewControllerDelegate Method
    //---------------------------------------------------
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func editButtonTapped(sender: UIBarButtonItem) {
        performSegueWithIdentifier("editRecruit", sender: self)

    }
    
    /*
    -------------------------
    MARK: - Prepare for Segue
    -------------------------
    
    This method is called by the system whenever you invoke the method performSegueWithIdentifier:sender:
    You never call this method. It is invoked by the system.
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
         if segue.identifier == "editRecruit" {
            
            // Obtain the object reference of the destination view controller
            let editRecruitViewController: EditRecruitViewController = segue.destinationViewController as! EditRecruitViewController
            
            // Under the Delegation Design Pattern, set the addCityViewController's delegate to be self
            editRecruitViewController.dataObjectPassed = dataObjectPassed
        }
    }

    
    //Registers the background touch
    @IBAction func backgroundTouch(sender: UIControl) {
        // Deactivate the Address Text Field object and remove the Keyboard
        notesTextView.resignFirstResponder()

    }
    
    
}
