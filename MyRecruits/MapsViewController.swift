//
//  MapsViewController.swift
//  MyRecruits
//
//  Created by Andrew Mogg on 12/3/15.
//  Copyright © 2015 Andrew Mogg. All rights reserved.
//

import UIKit
import CoreLocation
import AddressBook
import MapKit
import Contacts


class MapsViewController: UIViewController, CLLocationManagerDelegate {
    
    //Text Fields
    @IBOutlet var destinationTextField: UITextField!
    @IBOutlet var streetTextField: UITextField!
    @IBOutlet var cityTextField: UITextField!
    @IBOutlet var stateTextField: UITextField!
    @IBOutlet var zipcodeTextField: UITextField!
    
    //Scroll View Labels and Images
    @IBOutlet var ForecastDayOneImage: UIImageView!
    @IBOutlet var ForecastDayTwoImage: UIImageView!
    @IBOutlet var ForecastDayThreeImage: UIImageView!
    @IBOutlet var ForecastDayFourImage: UIImageView!
    @IBOutlet var ForecastDayFiveImage: UIImageView!
    @IBOutlet var ForecastDayOneLabel: UILabel!
    @IBOutlet var ForecastDayTwoLabel: UILabel!
    @IBOutlet var ForecastDayThreeLabel: UILabel!
    @IBOutlet var ForecastDayFourLabel: UILabel!
    @IBOutlet var ForecastDayFiveLabel: UILabel!
    @IBOutlet var forecastCityLabel: UILabel!
    
    //Global variable used for determing location
    var coords: CLLocationCoordinate2D?
    
    // Declare a property to contain the absolute file path for the maps.html file
    var mapsHtmlFilePath: String?
    
    //Address variables
    var addressEnteredToShowOnMap = ""
    var curLoc = ""
    var selectedCityName: String = ""
    
    //Key for weather API
    var appKey: String = "37fb28a23a5078cd37ad558eb1e9bc25"
    
    // dataObjectToPass is the data object to pass to the downstream view controller (i.e., AddressMapViewController)
    var dataObjectToPass: [String] = ["googleMapQuery", "adressEnteredToShowOnMap"]
    
    // Instantiate a CLLocationManager object
    var locationManager = CLLocationManager()
    
    var userAuthorizedLocationMonitoring = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapsHtmlFilePath = NSBundle.mainBundle().pathForResource("maps", ofType: "html")

        /*
        IMPORTANT NOTE: Current GPS location cannot be determined under the iOS Simulator
        on your laptop or desktop computer because those computers do NOT have a GPS antenna.
        Therefore, do NOT expect the code herein to work under the iOS Simulator!
        
        You must deploy your location-aware app to an iOS device to be able to test it properly.
        
        To develop a location-aware app:
        
        (1) Link to CoreLocation.framework in your Xcode project
        (2) Include "import CoreLocation" to use its classes.
        (3) Study documentation on CLLocation, CLLocationManager, and CLLocationManagerDelegate
        */
        
        /*
        The user can turn off location services on an iOS device in Settings.
        First, you must check to see of it is turned off or not.
        */
        
        if !CLLocationManager.locationServicesEnabled() {
            
            /*
            Create a UIAlertController object; dress it up with title, message, and preferred style;
            and store its object reference into local constant alertController
            */
            let alertController = UIAlertController(title: "Location Services Disabled!",
                message: "Turn Location Services On in your device settings to be able to use location services!",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            // Create a UIAlertAction object and add it to the alert controller
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            
            // Present the alert controller by calling the presentViewController method
            presentViewController(alertController, animated: true, completion: nil)
            
            return
        }
        
        /*
        Monitoring the user's current location is a serious privacy issue!
        You are required to get the user's permission in two ways:
        
        (1) requestWhenInUseAuthorization:
        (a) Ask your locationManager to request user's authorization while the app is being used.
        (b) Add a new row in the Info.plist file for NSLocationWhenInUseUsageDescription, for which you specify, e.g.,
        "VTQuest requires monitoring your location only when you are using the app!"
        
        (2) requestAlwaysAuthorization:
        (a) Ask your locationManager to request user's authorization even when the app is not being used.
        (b) Add a new row in the Info.plist file for NSLocationAlwaysUsageDescription, for which you specify, e.g.,
        "VTQuest requires monitoring your location even when you are not using your app!"
        
        You select and use only one of these two options depending on your app's requirement.
        */
        
        // We will use Option 1: Request user's authorization while the app is being used.
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.Denied {
            userAuthorizedLocationMonitoring = false
        } else {
            userAuthorizedLocationMonitoring = true
        }
        
        // Obtain the absolute file path to the maps.html file in the main bundle
        mapsHtmlFilePath = NSBundle.mainBundle().pathForResource("maps", ofType: "html")
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
        streetTextField.resignFirstResponder()
        cityTextField.resignFirstResponder()
        stateTextField.resignFirstResponder()
        zipcodeTextField.resignFirstResponder()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    ///////////////////////
    //Get Directions
    ///////////////////////
    @IBAction func getDirectionsButtonTapped(sender: UIButton) {
        
        // If no address is entered, alert the user
        if  streetTextField.text == "" || cityTextField.text == "" || stateTextField.text == ""{
            /*
            Create a UIAlertController object; dress it up with title, message, and preferred style;
            and store its object reference into local constant alertController
            */
            let alertController = UIAlertController(title: "Text Field Missing!",
                message: "Please enter at least the city and state.",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            // Create a UIAlertAction object and add it to the alert controller
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            
            // Present the alert controller by calling the presentViewController method
            presentViewController(alertController, animated: true, completion: nil)
            
            return
        }
        //If the current location can't be determined, alert user
        if !userAuthorizedLocationMonitoring {
            
            // User does not authorize location monitoring
            
            /*
            Create a UIAlertController object; dress it up with title, message, and preferred style;
            and store its object reference into local constant alertController
            */
            let alertController = UIAlertController(title: "Authorization Denied!",
                message: "Unable to determine current location!",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            // Create a UIAlertAction object and add it to the alert controller
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            
            // Present the alert controller by calling the presentViewController method
            presentViewController(alertController, animated: true, completion: nil)
            
            return
        }
        let geoCoder = CLGeocoder()
        
        let addressString = "\(streetTextField.text!) \(cityTextField.text!) \(stateTextField.text!) \(zipcodeTextField.text!)"
    
        geoCoder.geocodeAddressString(addressString, completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) -> Void in
        //Can't find the correct address
        if error != nil {
            print("Geocode failed with error: \(error!.localizedDescription)")
            /*
            Create a UIAlertController object; dress it up with title, message, and preferred style;
            and store its object reference into local constant alertController
            */
            let alertController = UIAlertController(title: "Trouble Locating!",
                message: "Geocode failed with error: \(error!.localizedDescription). Try Again.",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            // Create a UIAlertAction object and add it to the alert controller
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            
            // Present the alert controller by calling the presentViewController method
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        //Find yourself and display it in the map app
        else if placemarks!.count > 0 {
            let placemark = placemarks![0] 
            let location = placemark.location
            self.coords = location!.coordinate
    
            self.showMap()
    
        }
        })
        
        destinationTextField.text! = ""
        streetTextField.text! = ""
        cityTextField.text! = ""
        stateTextField.text! = ""
        zipcodeTextField.text! = ""
    }
    
    /*
    * Open up the build in map app with directions to desired location.
    */
    func showMap() {
        //Store the inputted data into an address dictionary
        let addressDict: [String: AnyObject] =
        [CNPostalAddressStreetKey: streetTextField.text!,
            CNPostalAddressCityKey as String: cityTextField.text!,
            CNPostalAddressStateKey as String: stateTextField.text!,
            CNPostalAddressPostalCodeKey as String: zipcodeTextField.text!]
        
        let place = MKPlacemark(coordinate: coords!,
            addressDictionary: addressDict)
        
        let mapItem = MKMapItem(placemark: place)
        
        let options = [MKLaunchOptionsDirectionsModeKey:
            MKLaunchOptionsDirectionsModeDriving]
        
        mapItem.name = "\(destinationTextField!.text!)"
        mapItem.openInMapsWithLaunchOptions(options)
    }
    @IBAction func bookHotelButtonTapped(sender: UIButton) {
        performSegueWithIdentifier("bookHotel", sender: self)
    }
    @IBAction func checkWeatherButtonTapped(sender: UIButton) {
        if  cityTextField.text == "" {
            /*
            Create a UIAlertController object; dress it up with title, message, and preferred style;
            and store its object reference into local constant alertController
            */
            let alertController = UIAlertController(title: "Selection Missing",
                message: "Please enter a City!",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            // Create a UIAlertAction object and add it to the alert controller
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            
            // Present the alert controller by calling the presentViewController method
            presentViewController(alertController, animated: true, completion: nil)
            
            return
        }
        selectedCityName = cityTextField.text!
        forecastCityLabel.text! = "5 Day Forecast for \(selectedCityName)"
        processWeather()
    }
    
    /*
    --------------------------
    MARK: - Process Weather JSON Data
    --------------------------
    */
    func processWeather() {
        var weatherData: NSData
        // Declare local variables
        
        let searchNameNoSpaces = selectedCityName.stringByReplacingOccurrencesOfString(" ", withString: "+")
        // Compose the search query containing the barcode, appID, and appKey
        let weatherURL = "http://api.openweathermap.org/data/2.5/forecast/daily?q=\(searchNameNoSpaces),us&mode=json&units=imperial&cnt=5&APPID=\(appKey)"

        let weatherDataReturned: NSData? = NSData(contentsOfURL: NSURL(string: weatherURL)!)
        
        if let weatherDataObtained = weatherDataReturned {
            
            weatherData = weatherDataObtained
            
        } else {
            /*
            Create a UIAlertController object; dress it up with title, message, and preferred style;
            and store its object reference into local variable alertController
            */
            let alertController = UIAlertController(title: "Weather Data Unavailable!",
                message: "No results found for the weather data.",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            // Create a UIAlertAction object and add it to the alert controller
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction) in
            }))
            
            // Present the alert controller by calling the presentViewController method
            presentViewController(alertController, animated: true, completion: nil)
            
            return
        }
        
        /*
        NSJSONSerialization class is used to convert JSON and Foundation objects (e.g., NSDictionary) into each other.
        NSJSONSerialization class's method JSONObjectWithData returns an NSDictionary object from the given JSON data.
        */
        let jsonDict: NSDictionary = (try! NSJSONSerialization.JSONObjectWithData(weatherData, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
        
        let fiveDayForecast = jsonDict["list"] as! NSArray
        
        for (var i = 0; i < fiveDayForecast.count; i++)
        {
            let fiveDayResults = fiveDayForecast[i] as! [String: AnyObject]
            
            //Get the data for the icon
            let weatherForecast = fiveDayResults["weather"] as! NSArray
            let weatherDictionary = weatherForecast[0] as! [String: AnyObject]
            getWeatherIcon(weatherDictionary, count: i)
            
            //Get the data for the label
            let weatherDate = fiveDayResults["dt"] as! Int
            let weatherMax = fiveDayResults["temp"]?["max"] as! Float
            let weatherMin = fiveDayResults["temp"]?["min"] as! Float
            getLabel(weatherDate, weatherMax: weatherMax, weatherMin: weatherMin, count: i)
            
        }
    }
    
    /*
    * Get the data for the current label and print it to the corresponding label.
    */
    func getLabel(weatherDate: Int, weatherMax: Float, weatherMin: Float, count: Int)
    {
        var currentIcon: UILabel!
        if (count == 0)
        {
            currentIcon = ForecastDayOneLabel
        }
        if (count == 1)
        {
            currentIcon = ForecastDayTwoLabel
        }
        if (count == 2)
        {
            currentIcon = ForecastDayThreeLabel
        }
        if (count == 3)
        {
            currentIcon = ForecastDayFourLabel
        }
        if (count == 4)
        {
            currentIcon = ForecastDayFiveLabel
        }
        //Convert the UTC into mm/dd/year
        let value = Double(weatherDate)
        let doubleDate = NSDate(timeIntervalSince1970: value)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .ShortStyle
        let date = dateFormatter.stringFromDate(doubleDate)
        
        
        currentIcon.text = "\(date), High: \(weatherMax)F, Low: \(weatherMin)F"
    }
    
    /*
    * Get the icon for the weather
    */
    func getWeatherIcon(weatherDictionary: [String: AnyObject], count: Int)
    {
        var currentIcon: UIImageView!
        if (count == 0)
        {
            currentIcon = ForecastDayOneImage
        }
        if (count == 1)
        {
            currentIcon = ForecastDayTwoImage
        }
        if (count == 2)
        {
            currentIcon = ForecastDayThreeImage
        }
        if (count == 3)
        {
            currentIcon = ForecastDayFourImage
        }
        if (count == 4)
        {
            currentIcon = ForecastDayFiveImage
        }
        let keys = weatherDictionary.keys
        
        //Find the icon
        if keys.contains("main")
        {
            let weatherDescription = weatherDictionary["icon"] as! String
            if (weatherDescription == "01d")
            {
                currentIcon.image = UIImage(named: "01d")
            }
            if (weatherDescription == "01n")
            {
                currentIcon.image = UIImage(named: "01n")
            }
            if (weatherDescription == "02d")
            {
                currentIcon.image = UIImage(named: "02d.png")
            }
            if (weatherDescription == "02n")
            {
                currentIcon.image = UIImage(named: "02n.png")
            }
            if (weatherDescription == "03d")
            {
                currentIcon.image = UIImage(named: "03d.png")
            }
            if (weatherDescription == "03n")
            {
                currentIcon.image = UIImage(named: "03n.png")
            }
            if (weatherDescription == "04d")
            {
                currentIcon.image = UIImage(named: "04d.png")
            }
            if (weatherDescription == "04n")
            {
                currentIcon.image = UIImage(named: "04n.png")
            }
            
            if (weatherDescription == "09d")
            {
                currentIcon.image = UIImage(named: "09d.png")
            }
            if (weatherDescription == "09n")
            {
                currentIcon.image = UIImage(named: "09n.png")
            }
            
            if (weatherDescription == "10d")
            {
                currentIcon.image = UIImage(named: "10d")
            }
            if (weatherDescription == "10n")
            {
                currentIcon.image = UIImage(named: "10n")
            }
            
            if (weatherDescription == "11d")
            {
                currentIcon.image = UIImage(named: "11d.png")
            }
            if (weatherDescription == "11n")
            {
                currentIcon.image = UIImage(named: "11n.png")
            }
            
            if (weatherDescription == "13d")
            {
                currentIcon.image = UIImage(named: "13d.png")
            }
            if (weatherDescription == "13n")
            {
                currentIcon.image = UIImage(named: "13n.png")
            }
            if (weatherDescription == "50d"){
                
                currentIcon.image = UIImage(named: "50d.png")
            }
            if (weatherDescription == "50n")
            {
                currentIcon.image = UIImage(named: "50d.png")
            }
        }
        
    }
    
    
}
