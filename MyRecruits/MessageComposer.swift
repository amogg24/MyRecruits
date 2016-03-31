//
//  MessageComposer.swift
//  MyRecruits
//
//  Created by Andrew Mogg on 12/3/15.
//  Copyright © 2015 Andrew Mogg. All rights reserved.
//

import Foundation
import MessageUI

/*
 * Helper class to compose a text message
 */
class MessageComposer: NSObject, MFMessageComposeViewControllerDelegate {
   
    var textMessageRecipients = [""]
    // A wrapper function to indicate whether or not a text message can be sent from the user's device
    func canSendText() -> Bool {
        return MFMessageComposeViewController.canSendText()
    }
    
    // Configures and returns a MFMessageComposeViewController instance
    func configuredMessageComposeViewController(number: String) -> MFMessageComposeViewController {
        let messageComposeVC = MFMessageComposeViewController()
        messageComposeVC.messageComposeDelegate = self  //  Make sure to set this property to self, so that the controller can be dismissed!
        textMessageRecipients = ["\(number)"]
        messageComposeVC.recipients = textMessageRecipients
        messageComposeVC.body = "Hey friend - Just sending a text message in-app using My Recruit!"
        return messageComposeVC
    }
    
    // MFMessageComposeViewControllerDelegate callback - dismisses the view controller when the user is finished with it
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}