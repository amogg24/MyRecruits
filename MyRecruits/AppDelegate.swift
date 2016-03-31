//
//  AppDelegate.swift
//  MyRecruits
//
//  Created by Andrew Mogg on 11/29/15.
//  Copyright © 2015 Andrew Mogg. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    //Global dictionaries for data
    var dict_RecruitInfo: NSMutableDictionary = NSMutableDictionary()
    var dict_Images = NSTemporaryDirectory() as NSString

    /*
    ---------------------------
    MARK: - Read the Dictionary
    ---------------------------
    */
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        /*
        All application-specific and user data must be written to files that reside in the iOS device's
        Documents directory. Nothing can be written into application's main bundle (project folder) because
        it is locked for writing after your app is published.
        
        The contents of the iOS device's Documents directory are backed up by iTunes during backup of an iOS device.
        Therefore, the user can recover the data written by your app from an earlier device backup.
        
        The Documents directory path on an iOS device is different from the one used for iOS Simulator.
        
        To obtain the Documents directory path, you use the NSSearchPathForDirectoriesInDomains function.
        However, this function was created originally for Mac OS X, where multiple such directories could exist.
        Therefore, it returns an array of paths rather than a single path.
        
        For iOS, the resulting array's first element (index=0) contains the path to the Documents directory.
        */
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentDirectoryPath = paths[0] as String
        
        // Add the plist filename to the documents directory path to obtain an absolute path to the plist filename
        let plistFilePathInDocumentDirectory = documentDirectoryPath + "/Recruits.plist"
        
        /*
        NSMutableDictionary manages an *unordered* collection of mutable (changeable) key-value pairs.
        Instantiate an NSMutableDictionary object and initialize it with the contents of the Recruits.plist file.
        */
        let dictionaryFromFile: NSMutableDictionary? = NSMutableDictionary(contentsOfFile: plistFilePathInDocumentDirectory)
        
        /*
        IF the optional variable dictionaryFromFile has a value, THEN
        Recruits.plist exists in the Documents directory and the dictionary is successfully created
        ELSE read CountryCities.plist from the application's main bundle.
        */
        if let dictionaryFromFileInDocumentDirectory = dictionaryFromFile {
            
            // CountryCities.plist exists in the Documents directory
            dict_RecruitInfo = dictionaryFromFileInDocumentDirectory
            
        } else {
            
            // CountryCities.plist does not exist in the Documents directory; Read it from the main bundle.
            
            // Obtain the file path to the plist file in the mainBundle (project folder)
            let plistFilePathInMainBundle = NSBundle.mainBundle().pathForResource("Recruits", ofType: "plist")
            
            // Instantiate an NSMutableDictionary object and initialize it with the contents of the CountryCities.plist file.
            let dictionaryFromFileInMainBundle: NSMutableDictionary? = NSMutableDictionary(contentsOfFile: plistFilePathInMainBundle!)
            
            // Assign it to the instance variable
            dict_RecruitInfo = dictionaryFromFileInMainBundle!
        }
        return true

    }

    /*
    ----------------------------
    MARK: - Write the Dictionary
    ----------------------------
    */
    func applicationWillResignActive(application: UIApplication) {
        /*
        "UIApplicationWillResignActiveNotification is posted when the app is no longer active and loses focus.
        An app is active when it is receiving events. An active app can be said to have focus.
        It gains focus after being launched, loses focus when an overlay window pops up or when the device is
        locked, and gains focus when the device is unlocked." [Apple]
        */
        
        // Define the file path to the Recruits.plist file in the Documents directory
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentDirectoryPath = paths[0] as String
        
        // Add the plist filename to the documents directory path to obtain an absolute path to the plist filename
        let plistFilePathInDocumentDirectory = documentDirectoryPath + "/Recruits.plist"
        
        // Write the NSMutableDictionary to the Recruits.plist file in the Documents directory
        dict_RecruitInfo.writeToFile(plistFilePathInDocumentDirectory, atomically: true)
    }


    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

