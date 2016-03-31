//
//  MyRecruitsTableViewController.swift
//  MyRecruits
//
//  Created by Andrew Mogg on 11/29/15.
//  Copyright © 2015 Andrew Mogg. All rights reserved.
//

import UIKit

class MyRecruitsTableViewController: UITableViewController {
    
    @IBOutlet var myRecruitsTableView: UITableView!
    // Obtain the object reference to the App Delegate object
    let applicationDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let tableViewRowHeight: CGFloat = 90.0

    var recruitData = [String]()
    
    //Passed to Recruit Info and Add Recruit class
    var dataObjectToPass: [String] = ["Name", "Hometown", "Grad Year", "Commitment", "Position", "HS", "GPA", "Notes", "Image", "Skill Level", "Email", "Phone Number"]
    
    //Local dictionary to provide alpbetically sorting
    var dict_Letter_Names  = [String: AnyObject]()
    
    //The choice for filtering
    var filterChoice = ""
    
    // An object reference pointing to an array containing the starting letters of names
    var firstLettersOfNames = [String]()
   
    override func viewDidLoad() {
        // Set up the Add button on the right of the navigation bar to call the addCity method when tapped
        let addButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addRecruit:")
        self.navigationItem.rightBarButtonItem = addButton
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

        reloadAllData()
        
        //Store all the images to the image.plist for ease of access
        for (var i = 0; i < recruitData.count; i++) {
            let temp = applicationDelegate.dict_RecruitInfo[recruitData[i]] as! [String]
            let imageName = temp[7]
            
            //Save the image names
            if let image = (UIImage(named: imageName)) {
                let imageData = NSData(data:UIImagePNGRepresentation(image)!)
                let fullPath = applicationDelegate.dict_Images.stringByAppendingPathComponent("\(imageName)")
                imageData.writeToFile(fullPath, atomically: true)
            }
        }
        
    }
    
    /*
    * This function regengates the two arrays used to populate the table view: recruitData and firstLetterOfNames
    */
    func reloadAllData() {
        recruitData = applicationDelegate.dict_RecruitInfo.allKeys as! [String]
        
        // Sort the country names within itself in alphabetical order
        recruitData.sortInPlace { $0 < $1 }
        
        // Obtain the name of the first VT place from the global data
        if (!recruitData.isEmpty) {
            let firstName = recruitData[0]
            
            // Create an array with its first value being firstName
            var namesForLetter = [String]()
            namesForLetter.append(firstName)
            
            // Instantiate a character string object containing the letter A
            // and store its object reference into the local variable previousLetter
            let index = firstName.startIndex.advancedBy(1)
            var previousFirstLetter: Character = Character(firstName.substringToIndex(index))
            
            // Store the number of names into local variable noOfPlaces
            let noOfPlaces = recruitData.count
            
            // Since we already stored the first name at index 0, we start index j with 1
            for (var j = 1; j < noOfPlaces; j++) {
                
                // Obtain the jth VT place name
                let placeName = recruitData[j]
                
                // Obtain the first character of the name. An easy way of doing this:
                // Convert the placeName string into an array of characters and select the one at index 0.
                let currentFirstLetter: Character = Array(placeName.characters)[0]
                
                if currentFirstLetter == previousFirstLetter {
                    
                    namesForLetter.append(placeName)
                    
                } else {
                    // Add array of names starting with previousFirstLetter to the dictionary
                    dict_Letter_Names[String(previousFirstLetter)] = namesForLetter
                    
                    previousFirstLetter = currentFirstLetter
                    
                    // Empty the placeNamesForLetter array
                    namesForLetter.removeAll(keepCapacity: false)
                    
                    // Set the value at index 0 to placeName
                    namesForLetter.append(placeName)
                }
            }
            
        
            // Add array of names starting with previousFirstLetter to the dictionary
            dict_Letter_Names[String(previousFirstLetter)] = namesForLetter
        }
        // Obtain the index letters to diplay for the user to select one to jump to its section
        firstLettersOfNames  = Array(dict_Letter_Names.keys)
        
        // Sort the index letters within itself in alphabetical order
        firstLettersOfNames.sortInPlace { $0 < $1 }
        
        myRecruitsTableView.reloadData()

    }
    
    /*
    -----------------------
    MARK: - Add Recruit Method
    -----------------------
    */
    
    // The addCity method is invoked when the user taps the Add button created in viewDidLoad() above.
    func addRecruit(sender: AnyObject) {
        
        // Perform the segue named AddCity
        performSegueWithIdentifier("AddRecruit", sender: self)
    }

    //----------------------------------------
    // Return Number of Sections In Table View
    //----------------------------------------
    // Asks the data source to return the number of sections in the table view
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        // number of table sections = number of letters
        return firstLettersOfNames.count
    }
    
    //--------------------------------
    // Return Number of Rows in Section
    //--------------------------------
    
    // Number of rows in a given section (index letter) = Number of VT place names starting with that letter
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Obtain the index letter for the given section number
        let indexLetter = firstLettersOfNames[section]
        
        // Obtain the object reference to the array containing the place names starting with that index letter
        let arrayOfNames: AnyObject? = dict_Letter_Names[indexLetter]
        
        // Unwrap and typecast the object pointed to by arrayOfPlaceNames as an array of String values
        let listOfNames = arrayOfNames! as! [String]
        
        // Number of place names starting with the index letter = Number of rows in that index letter section
        return listOfNames.count
    }
    
    //----------------------------
    // Set Title for Section Header
    //----------------------------
    
    // Asks the data source to return the section title for a given section number
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String {
        
        return firstLettersOfNames[section]
    }

    
    //--------------------------------
    // Populate the Cells
    //--------------------------------
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell: MyRecruitsTableViewCell = tableView.dequeueReusableCellWithIdentifier("RecruitCellType") as! MyRecruitsTableViewCell
        let rowNumber: Int = indexPath.row    // Identify the row number
        let sectionNumber = indexPath.section
        
        // Obtain the index letter for the given section number
        let indexLetter = firstLettersOfNames[sectionNumber]
        
        // Obtain the object reference to the array containing the names starting with that index letter
        let arrayOfNames: AnyObject? = dict_Letter_Names[indexLetter]
        
        // Unwrap and typecast the object pointed to by arrayOfPlaceNames as an array of String values
        var listOfNames = arrayOfNames! as! [String]
        
        // Obtain the place name at the row number
        let selectedName = listOfNames[rowNumber]
        let fullNameArray = selectedName.componentsSeparatedByString(" ")
        let lastName = fullNameArray[1]
        
        //Get the Array of data for the selected name
        let recruitDataArray: AnyObject? = applicationDelegate.dict_RecruitInfo[selectedName]
        let recruitArray = recruitDataArray! as! [String]
        
        //Search for the image in the image.plist and set the image
        let nsDocumentDirectory = NSSearchPathDirectory.DocumentDirectory
        let nsUserDomainMask    = NSSearchPathDomainMask.UserDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        
        if paths.count > 0
        {
            let readPath = applicationDelegate.dict_Images.stringByAppendingPathComponent("\(lastName).png")
            let image    = UIImage(contentsOfFile: readPath)
            cell.recruitPic!.image = image
        }
        
        //Set the cell with its corresponding data
        cell.recruitName!.text = selectedName
        cell.recruitHometown!.text = recruitArray[0]
        cell.recruitGradYear!.text = recruitArray[1]
        cell.recruitPosition!.text = recruitArray[3]
        
        return cell

    }
    
    /*
    -----------------------------------
    MARK: - Table View Delegate Methods
    -----------------------------------
    */
    
    // Asks the table view delegate to return the height of a given row.
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return tableViewRowHeight
    }
    
    //--------------------------------
    // Filter the Search Results
    //--------------------------------
    /*
    Informs the table view delegate that the table view is about to display a cell for a particular row.
    Just before the cell is displayed, we change the cell's background color as OLD_LACE for the filtered
    choice.
    */
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        // Define OldLace color: #FDF5E6   253,245,230
        let OLD_LACE = UIColor(red: 253.0/255.0, green: 245.0/255.0, blue: 230.0/255.0, alpha: 1.0)

        let rowNumber: Int = indexPath.row    // Identify the row number
        let sectionNumber = indexPath.section
        
        // Obtain the index letter for the given section number
        let indexLetter = firstLettersOfNames[sectionNumber]
        
        // Obtain the object reference to the array containing the place names starting with that index letter
        let arrayOfNames: AnyObject? = dict_Letter_Names[indexLetter]
        
        // Unwrap and typecast the object pointed to by arrayOfNames as an array of String values
        var listOfNames = arrayOfNames! as! [String]
        
        // Obtain the place name at the row number
        let selectedName = listOfNames[rowNumber]
        
        let recruitDataArray: AnyObject? = applicationDelegate.dict_RecruitInfo[selectedName]
        let recruitArray = recruitDataArray! as! [String]
        
        //Display the recruit based on the filtered choice
        if (filterChoice == "Commitment" && recruitArray[2] == "VT")
        {
            cell.backgroundColor = OLD_LACE
        }
        else if (filterChoice == recruitArray[3])
        {
            cell.backgroundColor = OLD_LACE
        }
        else {
            cell.backgroundColor = UIColor.whiteColor()
        }
        
    }
    
    //----------------------------
    // Return Section Index Titles
    //----------------------------
    
    /*
    Asks the data source to return all of the section titles, i.e., letters from A to Z to display them as an
    index on the right side of the table view so that the user can tap on a letter to jump to its section.
    */
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return firstLettersOfNames
    }
    
    //----------------
    // Row Is Selected
    //----------------
    /*
     * Informs the table view delegate that the user tapped the selected the row
     */
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let rowNumber: Int = indexPath.row    // Identify the row number
        let sectionNumber = indexPath.section
        
        // Obtain the index letter for the given section number
        let indexLetter = firstLettersOfNames[sectionNumber]
        
        // Obtain the object reference to the array containing the place names starting with that index letter
        let arrayOfNames: AnyObject? = dict_Letter_Names[indexLetter]
        
        // Unwrap and typecast the object pointed to by arrayOfPlaceNames as an array of String values
        var listOfNames = arrayOfNames! as! [String]
        
        // Obtain the place name at the row number
        let selectedName = listOfNames[rowNumber]
        
        let recruitDataArray: AnyObject? = applicationDelegate.dict_RecruitInfo[selectedName]
        let recruitArray = recruitDataArray! as! [String]

        //Set the data to pass downstream
        dataObjectToPass[0] = selectedName          //Name
        dataObjectToPass[1] = recruitArray[0]       //Hometown
        dataObjectToPass[2] = recruitArray[1]       //Grad Year
        dataObjectToPass[3] = recruitArray[2]       //Commitment
        dataObjectToPass[4] = recruitArray[3]       //Position
        dataObjectToPass[5] = recruitArray[4]       //High School
        dataObjectToPass[6] = recruitArray[5]       //GPA
        dataObjectToPass[7] = recruitArray[6]       //Notes
        dataObjectToPass[8] = recruitArray[7]       //Image
        dataObjectToPass[9] = recruitArray[8]       //Skill Level
        dataObjectToPass[10] = recruitArray[9]      //Email
        dataObjectToPass[11] = recruitArray[10]     //Phone

        performSegueWithIdentifier("ShowRecruitInfo", sender: self)
    }
    /*
    -----------------
    MARK: - Unwinding
    -----------------
    */
    @IBAction func UnwindToMyMoviesTableViewController(segue: UIStoryboardSegue) {
        //Save the New recruit
        if segue.identifier == "AddRecruit-Save" {
            let controller: AddRecruitViewController = segue.sourceViewController as! AddRecruitViewController
            
            //Get the text field and segmented control data
            let nameEntered: String = controller.nameTextField.text!
            let hometownEntered: String = controller.hometownTextField.text!
            let gradYearEntered: String = controller.yearTextField.text!
            let commitmentEntered: String = controller.commitmentTextField.text!
            let positionEntered: String = controller.position
            let highSchoolEntered: String = controller.highSchoolTextField.text!
            let gpaEntered: String = controller.gpaTextField.text!
            let notesEntered: String = controller.bioTextField.text!
            let emailEntered: String = controller.emailTextField.text!
            let phoneEntered: String = controller.phoneNumberTextField.text!
           
            let fullNameArray = nameEntered.componentsSeparatedByString(" ")
            let lastName = fullNameArray[1]
            
            //Save the image to the image plist
            let imageEntered: String = lastName + ".png"
            let profilePhoto = controller.pictureImageView.image!
            let imageData = NSData(data:UIImagePNGRepresentation(profilePhoto)!)
            let fullPath = applicationDelegate.dict_Images.stringByAppendingPathComponent("\(lastName).png")
            imageData.writeToFile(fullPath, atomically: true)
    
            let skillLevelEntered: Int = controller.skillLevelSegmentedControl.selectedSegmentIndex
            
            //Alert the user if a field is empty
            if (nameEntered == "" || hometownEntered == "" || gradYearEntered == "" || commitmentEntered == "" || highSchoolEntered == "" || gpaEntered == "" || notesEntered == "" || emailEntered == "" || phoneEntered == "") {
                let alertController = UIAlertController(title: "Must Enter all Fields",
                    message: "All text fields must have input",
                    preferredStyle: UIAlertControllerStyle.Alert)
                
                // Create a UIAlertAction object and add it to the alert controller
                alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                
                // Present the alert controller by calling the presentViewController method
                presentViewController(alertController, animated: true, completion: nil)
            }
            else {
                //Alert the user if the recruit already exists
                if recruitData.contains(nameEntered) {
                    let alertController = UIAlertController(title: "Try Again!",
                        message: "Recruit already exists",
                        preferredStyle: UIAlertControllerStyle.Alert)
                    
                    // Create a UIAlertAction object and add it to the alert controller
                    alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    
                    // Present the alert controller by calling the presentViewController method
                    presentViewController(alertController, animated: true, completion: nil)

                }
                else {   // The entered Genre name does not exist in the current dictionary
                    let newRecruit: [String] = [hometownEntered, gradYearEntered, commitmentEntered, positionEntered, highSchoolEntered, gpaEntered, notesEntered, imageEntered, "\(skillLevelEntered)", emailEntered, phoneEntered]
                    applicationDelegate.dict_RecruitInfo.setObject(newRecruit, forKey: nameEntered)
                }
                
                reloadAllData()
            }
        }
        
        //if the edit field is saved
        if segue.identifier == "EditRecruit-Save" {
            let controller: EditRecruitViewController = segue.sourceViewController as! EditRecruitViewController
            
            //Get the text field and segmented control data
            let nameEntered: String = controller.nameTextField.text!
            let hometownEntered: String = controller.hometownTextField.text!
            let gradYearEntered: String = controller.yearTextField.text!
            let commitmentEntered: String = controller.commitmentTextField.text!
            let positionEntered: String = controller.position
            let highSchoolEntered: String = controller.highSchoolTextField.text!
            let gpaEntered: String = controller.gpaTextField.text!
            let notesEntered: String = controller.bioTextField.text!
            let emailEntered: String = controller.emailTextField.text!
            let phoneEntered: String = controller.phoneNumberTextField.text!
            
            let fullNameArray = nameEntered.componentsSeparatedByString(" ")
            let lastName = fullNameArray[1]
            
            //Save the image to the image plist
            let imageEntered: String = lastName + ".png"
            let profilePhoto = controller.pictureImageView.image!
            let imageData = NSData(data:UIImagePNGRepresentation(profilePhoto)!)
            let fullPath = applicationDelegate.dict_Images.stringByAppendingPathComponent("\(lastName).png")
            imageData.writeToFile(fullPath, atomically: true)
            
            let skillLevelEntered: Int = controller.skillLevelSegmentedControl.selectedSegmentIndex
            
            //Alert the user if a field is empty
            if (nameEntered == "" || hometownEntered == "" || gradYearEntered == "" || commitmentEntered == "" || highSchoolEntered == "" || gpaEntered == "" || notesEntered == "" || emailEntered == "" || phoneEntered == "") {
                let alertController = UIAlertController(title: "Must Enter all Fields",
                    message: "All text fields must have input",
                    preferredStyle: UIAlertControllerStyle.Alert)
                
                // Create a UIAlertAction object and add it to the alert controller
                alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                
                // Present the alert controller by calling the presentViewController method
                presentViewController(alertController, animated: true, completion: nil)
            }
            else {
                //Write the new contact to the plist. It will update existing, and add new if the name changes
                let newRecruit: [String] = [hometownEntered, gradYearEntered, commitmentEntered, positionEntered, highSchoolEntered, gpaEntered, notesEntered, imageEntered, "\(skillLevelEntered)", emailEntered, phoneEntered]
                applicationDelegate.dict_RecruitInfo.setObject(newRecruit, forKey: nameEntered)
                
                reloadAllData()
            }
        }
        //Get the filtered choice
        if segue.identifier == "Filter" {
            let controller: FilterViewController = segue.sourceViewController as! FilterViewController
            filterChoice = controller.position
        }
        

    }
    
    //-------------------------------
    // Allow Editing of Rows (Movies)
    //-------------------------------
    
    // We allow each row (city) of the table view to be editable, i.e., deletable or movable
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    //---------------------
    // Delete Button Tapped
    //---------------------
    
    //This is the method invoked when the user taps the Delete button in the Edit mode
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {   // Handle the Delete action
            
            let rowNumber: Int = indexPath.row    // Identify the row number
            let sectionNumber = indexPath.section

            // Obtain the index letter for the given section number
            let indexLetter = firstLettersOfNames[sectionNumber]
            
            // Obtain the object reference to the array containing the place names starting with that index letter
            let arrayOfNames: AnyObject? = dict_Letter_Names[indexLetter]
            
            // Unwrap and typecast the object pointed to by arrayOfPlaceNames as an array of String values
            var listOfNames = arrayOfNames! as! [String]
            
            // Obtain the place name at the row number
            let selectedName = listOfNames[rowNumber]

            //Obtain the letter to delete
            let letterToDelete = firstLettersOfNames[sectionNumber]
            let letterData = dict_Letter_Names[letterToDelete]
            var letterArray = letterData! as! [String]
            
            //Remove from letter array and recruit dictionary
            letterArray.removeAtIndex(rowNumber)
            applicationDelegate.dict_RecruitInfo.removeObjectForKey(selectedName)
            
            // If no names remains in the array after deletion, then we need to also delete the letter
            if letterArray.count == 0 {
                dict_Letter_Names.removeValueForKey(letterToDelete)
            }
            else {
                //Update the section
                dict_Letter_Names.updateValue(letterArray, forKey: letterToDelete)

                // Reload the rows and sections of the Table View MyMovieTableView
                myRecruitsTableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Automatic)
            }
            reloadAllData()
        }
    }

    
    /*
    -------------------------
    MARK: - Prepare For Segue
    -------------------------
    */
    
    // This method is called by the system whenever you invoke the method performSegueWithIdentifier:sender:
    // You never call this method. It is invoked by the system.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if segue.identifier == "ShowRecruitInfo" {
            
            // Obtain the object reference of the destination view controller
            let recruitInfoViewController: RecruitInfoViewController = segue.destinationViewController as! RecruitInfoViewController
            
            //Pass the data object to the destination view controller object
            recruitInfoViewController.dataObjectPassed = dataObjectToPass            
        }
    }
    
    //----------------------
    //  Filter Button Tapped
    //----------------------
    
    @IBAction func filterButtonTapped(sender: UIBarButtonItem) {
        performSegueWithIdentifier("chooseFilter", sender: self)
    }
}

