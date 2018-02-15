//
//  MapViewController.swift
//  Helpem
//
//  Created by Nicholas Jaimes on 11/6/17.
//  Copyright © 2017 Nicholas Jaimes. All rights reserved.
//

import UIKit
import MapKit
import Foundation

class MapViewController: UIViewController, CLLocationManagerDelegate {

    /*
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    */

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    var userLatitude = 0.0
    var userLongitude = 0.0
    
    
    @IBOutlet weak var lblUsername: UILabel!
    
    
    @IBOutlet var mapView: MKMapView!
    
    var locationManager: CLLocationManager?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("MAPVIEWCONTROLLER LOADED")
        
        // Do any additional setup after loading the view.
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        
        var printAuthorizationStatus = "CLLocationManager AuthorizationStatus = "
        printAuthorizationStatus.append(String(describing: CLLocationManager.authorizationStatus()))
        print(printAuthorizationStatus)
        
        /*
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            print("CLLManager authorizationStatus == whenInUse")
            locationManager!.startUpdatingLocation()
        } else {
            print("CLLManager authorizationStatus != whenInUse")
            locationManager!.requestWhenInUseAuthorization()
        }
        */
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            print("CLLManager authorizationStatus == whenInUse")
            locationManager!.startUpdatingLocation()
        }
        else if CLLocationManager.authorizationStatus() == .authorizedAlways {
            print("CLLManager authorizationStatus == always")
            locationManager!.startUpdatingLocation()
        }
        else {
            print("CLLManager authorizationStatus != whenInUse")
            locationManager!.requestWhenInUseAuthorization()
        }
    }
    
    /*
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        
        switch status {
        case .notDetermined:
            print("NotDetermined")
        case .restricted:
            print("Restricted")
        case .denied:
            print("Denied")
        case .authorizedAlways:
            print("AuthorizedAlways")
        case .authorizedWhenInUse:
            print("AuthorizedWhenInUse")
            locationManager!.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.first!
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 500, 500)
        mapView.setRegion(coordinateRegion, animated: true)
        locationManager?.stopUpdatingLocation()
        locationManager = nil
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Failed to initialize GPS: ", error.description)
    }
    */
    
    
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        var printStatusString = "status = "
        printStatusString.append(String(describing: status))
        print(printStatusString)
        
        switch status {
        case .notDetermined:
            print("NotDetermined")
        case .restricted:
            print("Restricted")
        case .denied:
            print("Denied")
        case .authorizedAlways:
            print("AuthorizedAlways")
        case .authorizedWhenInUse:
            print("AuthorizedWhenInUse")
            locationManager!.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print("MAPVIEWCONTROLLER LOCATIONMANAGER CALLED")
        let location = locations.first!
        userLatitude = location.coordinate.latitude
        userLongitude = location.coordinate.longitude
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 500, 500)
        mapView.setRegion(coordinateRegion, animated: true)
        locationManager?.stopUpdatingLocation()
        locationManager = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to initialize GPS: ", error)
    }
    
    
    struct postStruct
    {
        var id = ""
        var message = ""
        var longitude = ""
        var latitude = ""
        var duration = ""
        var timestamp = ""
        var username = ""
    }
    
    func getPostStructListFromResponseString(responseString : String) -> [postStruct]
    {
        var returningPostStructList = [postStruct()]
        
        var foundEntry = false
        
        var leftCurlyBracketCount = 0
        var rightCurlyBracketCount = 0
        
        var postStructListEntry = postStruct()
        var postStructElementEntry = ""
        
        
        for char in responseString
        {
            if char == "}"
            {
                foundEntry = false
                rightCurlyBracketCount += 1
                
                if leftCurlyBracketCount == 1
                {
                    postStructListEntry.id = postStructElementEntry
                }
                else if leftCurlyBracketCount == 2
                {
                    postStructListEntry.message = postStructElementEntry
                }
                else if leftCurlyBracketCount == 3
                {
                    postStructListEntry.longitude = postStructElementEntry
                }
                else if leftCurlyBracketCount == 4
                {
                    postStructListEntry.latitude = postStructElementEntry
                }
                else if leftCurlyBracketCount == 5
                {
                    postStructListEntry.duration = postStructElementEntry
                }
                else if leftCurlyBracketCount == 6
                {
                    postStructListEntry.timestamp = postStructElementEntry
                }
                else if leftCurlyBracketCount == 7
                {
                    postStructListEntry.username = postStructElementEntry
                }
                else
                {
                    
                }
            }
            
            if foundEntry == true
            {
                postStructElementEntry.append(char)
            }
            
            if char == "{"
            {
                foundEntry = true
                leftCurlyBracketCount += 1
                postStructElementEntry = ""
            }
            
            if rightCurlyBracketCount == 7
            {
                leftCurlyBracketCount = 0
                rightCurlyBracketCount = 0
                foundEntry = false
                returningPostStructList.append(postStructListEntry)
                postStructListEntry = postStruct()
                postStructElementEntry = ""
                
            }
        }
        
        return returningPostStructList
    }
    
    func printPostStructList(postStructList: [postStruct])
    {
        var postStructListEntryNumber = 1
        for postStructListEntry in postStructList
        {
            print("entry # = " + String(postStructListEntryNumber))
            print("id = " + postStructListEntry.id)
            print("message = " + postStructListEntry.message)
            print("longitude = " + postStructListEntry.longitude)
            print("latitude = " + postStructListEntry.latitude)
            print("duration = " + postStructListEntry.duration)
            print("timestamp = " + postStructListEntry.timestamp)
            print("username = " + postStructListEntry.username)
            
            postStructListEntryNumber += 1
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        let request = NSMutableURLRequest(url: NSURL (string: "http://njaimes2.create.stedwards.edu/helpem/getPosts.php")! as URL)
        request.httpMethod = "POST"
        
        //let postString = "a=\(txtUsername.text!)&b=\(txtPassword.text!)"
        
        //request.httpBody = postString.data(using: String.Encoding.utf8)
        
        //var wasQuerySucessful = false
        //var responseString2 = ""
        
        var theResponseString = ""
        
        var queryResult = ""
        
        var queryUsername = ""
        
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
            
            
            //let postStructList = self.getPostStructListFromResponseString(responseString: String(describing: responseString!))
            
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
            
            if String(describing: responseString!).range(of:"{") != nil
            {
                //self.performSegue(withIdentifier: "MapSegue", sender: nil)
                queryResult = "SUCCESS"
                theResponseString = String(describing: responseString!)
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
                //self.performSegue(withIdentifier: "CreateAccountToMapSegue", sender: nil)
                
                var postStructList = self.getPostStructListFromResponseString(responseString: theResponseString)
                
                postStructList.remove(at: 0)
                
                self.printPostStructList(postStructList: postStructList)
                
                //remove all current annotations
                self.mapView.removeAnnotations(self.mapView.annotations)
                
                for postStructListEntry in postStructList
                {
                    //let userAndEntryDistanceInKm = self.getDistanceFromLatLonInKm(lat1: self.mapView.userLocation.coordinate.latitude, lon1: self.mapView.userLocation.coordinate.longitude, lat2: Double(postStructListEntry.latitude)!, lon2: Double(postStructListEntry.longitude)!)
                    
                    let userAndEntryDistanceInKm = self.getDistanceFromLatLonInKm(lat1: self.userLatitude, lon1: self.userLongitude, lat2: Double(postStructListEntry.latitude)!, lon2: Double(postStructListEntry.longitude)!)
                    
                    //let userAndEntryDistanceInKm = self.getDistanceFromLatLonInKm(lat1: (self.locationManager?.location?.coordinate.latitude)!, lon1: (self.locationManager?.location?.coordinate.longitude)!, lat2: Double(postStructListEntry.latitude)!, lon2: Double(postStructListEntry.longitude)!)
                    
                    let MAXIMUM_DISTANCE_IN_KM = 1.0
                    
                    var currentUserLongitudeStringTest = "user longitude = "
                    currentUserLongitudeStringTest.append(String(self.userLongitude))
                    var currentUserLatitudeStringTest = "user latitude = "
                    currentUserLatitudeStringTest.append(String(self.userLatitude))
                    
                    print(currentUserLatitudeStringTest)
                    print(currentUserLongitudeStringTest)
                    
                    var distanceStringTest = "post id: "
                    distanceStringTest.append(String(postStructListEntry.id))
                    distanceStringTest.append(" had a km distance of: ")
                    distanceStringTest.append(String(userAndEntryDistanceInKm))
                    distanceStringTest.append(" from the user's location.")
                    
                    print(distanceStringTest)
                    
                    
                    if userAndEntryDistanceInKm <= MAXIMUM_DISTANCE_IN_KM
                    {
                    
                        let annotation = MKPointAnnotation()
                    
                        //print("postStructListEntry = ")
                        //print(postStructListEntry.longitude)
                        annotation.coordinate.longitude = Double(postStructListEntry.longitude)!
                        annotation.coordinate.latitude = Double(postStructListEntry.latitude)!
                    
                        if postStructListEntry.username == activeUsername
                        {
                            annotation.title = "you said..."
                        }
                        else
                        {
                            annotation.title = postStructListEntry.username + " said..."
                        }
                    
                        annotation.subtitle = postStructListEntry.message
                    
                        self.mapView.addAnnotation(annotation)
                    }
                }
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
                let alertController = UIAlertController(title: "Nothing Around...", message: "No nearby posts found", preferredStyle: UIAlertControllerStyle.alert)
                
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
        
        
        lblUsername.text = activeUsername
    }
    
    
    func getDistanceFromLatLonInKm(lat1: Double,lon1: Double,lat2: Double,lon2: Double) -> Double
    {
    let R = 6371.0; // Radius of the earth in km
    let dLat = deg2rad(deg: lat2-lat1)  // deg2rad below
    let dLon = deg2rad(deg: lon2-lon1);
    let a =
    sin(dLat/2) * sin(dLat/2) +
    cos(deg2rad(deg: lat1)) * cos(deg2rad(deg: lat2)) *
    sin(dLon/2) * sin(dLon/2)
    ;
    let c = 2 * atan2(sqrt(a), sqrt(1-a));
    let d = R * c; // Distance in km
    return d;
    }
    
    func deg2rad(deg: Double) -> Double
    {
    return deg * (Double.pi/180)
    }
    
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func btnLogout(_ sender: Any) {
        performSegue(withIdentifier: "MapToLoginSegue", sender: nil)
    }
    
}
