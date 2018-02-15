//
//  SetTimeViewController.swift
//  Helpem
//
//  Created by Nicholas Jaimes on 11/9/17.
//  Copyright © 2017 Nicholas Jaimes. All rights reserved.
//

import UIKit
import CoreLocation

class SetTimeViewController: UIViewController, CLLocationManagerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    
    @IBOutlet weak var pikrTime: UIPickerView!
    
    let dayList = ["1 Day", "2 Days", "3 Days", "4 Days", "5 Days", "6 Days", "7 Days"]
    let hourList = ["0 Hours", "2 Hours", "4 Hours", "6 Hours", "8 Hours", "10 Hours", "12 Hours", "14 Hours", "16 Hours", "18 Hours", "20 Hours", "22 Hours"]
    
    var selectedDay = "1 Day"
    var selectedHour = "0 Hours"
    
    //pikrTime.delegate = self
    //pikrTime.dataSource = self
    
    // Used to start getting the users location
    let locationManager = CLLocationManager()
    var userLongitude = 0.0
    var userLatitude = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // For use when the app is open & in the background
        locationManager.requestAlwaysAuthorization()
        
        // For use when the app is open
        //locationManager.requestWhenInUseAuthorization()
        
        // If location services is enabled get the users location
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest // You can change the locaiton accuary here.
            locationManager.startUpdatingLocation()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0
        {
            return dayList.count
        }
        else
        {
            return hourList.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0
        {
            return dayList[row]
        }
        else
        {
            return hourList[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedDay = dayList[pikrTime.selectedRow(inComponent: 0)]
        selectedHour = hourList[pikrTime.selectedRow(inComponent: 1)]
    }
    
    /*
    func getPostTime() -> String
    {
        var returnString = "0"
        
        var dayString = ""
        dayLoop : for char in selectedDay
        {
            if char == " "
            {
                break dayLoop
            }
            dayString.append(char)
        }
        if dayString.count == 1
        {
            returnString.append("0")
            returnString.append(dayString)
        }
        else
        {
            returnString.append(dayString)
        }
        
        returnString.append(":")
        
        var hourString = ""
        hourLoop : for char in selectedHour
        {
            if char == " "
            {
                break hourLoop
            }
            hourString.append(char)
        }
        if hourString.count == 1
        {
            returnString.append("0")
            returnString.append(hourString)
        }
        else
        {
            returnString.append(hourString)
        }
        
        returnString.append(":00")
        
        return returnString
    }
     */
    
    func getPostTime() -> String
    {
        var returnString = ""
        
        var dayString = ""
        dayLoop : for char in selectedDay
        {
            if char == " "
            {
                break dayLoop
            }
            dayString.append(char)
        }
        
        var intDayString = Int(dayString)
        intDayString = intDayString! * 24
        
        
        var hourString = ""
        hourLoop : for char in selectedHour
        {
            if char == " "
            {
                break hourLoop
            }
            hourString.append(char)
        }
        
        let intHourString = Int(hourString)
        
        let intTimeString = intDayString! + intHourString!
        
        returnString = String(intTimeString)
        
        returnString.append(":00:00")
        
        return returnString
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // Print out the location to the console
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            //print(location.coordinate)
            userLongitude = location.coordinate.longitude
            userLatitude = location.coordinate.latitude
        }
    }
    
    
    // If we have been deined access give the user the option to change it
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == CLAuthorizationStatus.denied) {
            showLocationDisabledPopUp()
        }
    }
    
    
    // Show the popup to the user if we have been deined access
    func showLocationDisabledPopUp() {
        let alertController = UIAlertController(title: "Background Location Access Disabled",
                                                message: "In order to deliver pizza we need your location",
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(openAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    @IBAction func btnPost(_ sender: Any)
    {
        
        let request = NSMutableURLRequest(url: NSURL (string: "http://njaimes2.create.stedwards.edu/helpem/createPost.php")! as URL)
        request.httpMethod = "POST"
        
        //let tempTime = "001:01:00"
        let postTime = getPostTime()
        var postTimePrintString = "postTime = "
        postTimePrintString.append(postTime)
        print(postTimePrintString)
        
        let postString = "a=\(messageToPost)&b=\(userLongitude)&c=\(userLatitude)&d=\(postTime)&e=\(activeUsername)"
        
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        //var wasQuerySucessful = false
        //var responseString2 = ""
        
        var queryResult = ""
        
        //var queryUsername = ""
        
        let myGroup = DispatchGroup()
        
        myGroup.enter()
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(String(describing: error))")
                return
            }
            
            print("response = \(String(describing: response))")
            
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("responseString = \(String(describing: responseString!))")
            
            //responseString2 = String(describing: responseString!)
            
            //test code for verifying success
            //var wasQuerySucessful = false
            //if (responseString!.contains("Successfully added"))
            //if responseString?.range(of:"Successfully added") != nil
            //if String(describing: responseString!).range(of:"Successfully added") != nil
            /*
             if String(describing: responseString!).range(of:"Success") != nil
             {
             wasQuerySucessful = true
             }
             */
            
            if String(describing: responseString!).range(of:"Successfully added") != nil
            {
                //self.performSegue(withIdentifier: "MapSegue", sender: nil)
                queryResult = "SUCCESS"
                //let theResponseString = String(describing: responseString!)
                //queryUsername = self.getUsernameFromResponseString(responseString: theResponseString)
            }
            else if String(describing: responseString!).range(of:"Duplicate entry") != nil
            {
                /*
                 let alertController = UIAlertController(title: "Username already in use", message: "Please choose a different username for your account", preferredStyle: UIAlertControllerStyle.alert)
                 
                 alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                 
                 self.present(alertController, animated: true, completion: nil)
                 */
                queryResult = "DUPLICATE"
            }
            else
            {
                /*
                 let alertController = UIAlertController(title: "Woops...", message: "Error! Please try again later", preferredStyle: UIAlertControllerStyle.alert)
                 
                 alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                 
                 self.present(alertController, animated: true, completion: nil)
                 */
                queryResult = "ERROR"
            }
            
            myGroup.leave()
            
        }
        
        task.resume()
        
        /*if String(describing: responseString2).range(of:"uccess") != nil
         {
         wasQuerySucessful = true
         print("got here")
         }*/
        
        //sleep(3)
        
        /*
         if (wasQuerySucessful == true)
         {
         /*
         let alertController = UIAlertController(title: "Success", message: "New Account successfully created", preferredStyle: UIAlertControllerStyle.alert)
         
         alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
         
         self.present(alertController, animated: true, completion: nil)
         */
         
         performSegue(withIdentifier: "MapSegue", sender: nil)
         print("got here")
         }
         else
         {
         let alertController = UIAlertController(title: "Username already in use", message: "Please choose a different username for your account", preferredStyle: UIAlertControllerStyle.alert)
         
         alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
         
         self.present(alertController, animated: true, completion: nil)
         }
         */
        
        myGroup.notify(queue: .main) {
            if queryResult == "SUCCESS"
            {
                //activeUsername = queryUsername
                self.performSegue(withIdentifier: "SetTimeToMapSegue", sender: nil)
            }
            else if queryResult == "DUPLICATE"
            {
                //self.wipeAllTextInputs()
                
                let alertController = UIAlertController(title: "Username already in use", message: "Please choose a different username for your account", preferredStyle: UIAlertControllerStyle.alert)
                
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
            }
            else
            {
                let alertController = UIAlertController(title: "Whoops...", message: "Error! Please try again later", preferredStyle: UIAlertControllerStyle.alert)
                
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
        
    }
    
}
