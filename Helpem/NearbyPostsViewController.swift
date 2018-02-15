//
//  NearbyPostsViewController.swift
//  Helpem
//
//  Created by Nicholas Jaimes on 1/1/18.
//  Copyright © 2018 Nicholas Jaimes. All rights reserved.
//

import UIKit
import CoreLocation
import Foundation

class NearbyPostsViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {

    
    
    @IBOutlet weak var tblNearbyPosts: UITableView!
    
    // Used to start getting the users location
    let locationManager = CLLocationManager()
    var userLongitude = 0.0
    var userLatitude = 0.0
    
    var tableOfPostStructs = [postStruct()]
    
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
    
    
    
    override func viewDidAppear(_ animated: Bool)
    {
        
        let request = NSMutableURLRequest(url: NSURL (string: "http://njaimes2.create.stedwards.edu/helpem/getReportablePosts.php")! as URL)
        request.httpMethod = "POST"
        
        let postString = "a=\(activeUsername)"
        
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
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
                
                print("NearbyPosts ResponseString:")
                print(theResponseString)
                print("------end of NearbyPosts ResponseString------")
                
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
                
                //NOTE: weird bug in getPostStructListFromResponseString func that has the first index as inl for all entries
                postStructList.remove(at: 0)
                
                self.printPostStructList(postStructList: postStructList)
                
                var filteredPostStructList = [postStruct()]
                
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
                        filteredPostStructList.append(postStructListEntry)
                        
                        /*
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
                        */
                    }
                }
                
                print("filteredPostStructList:")
                self.printPostStructList(postStructList: filteredPostStructList)
                print("------end of filteredPostStructList------")
                
                //NOTE: filtered list is for some reason empty on first entry
                filteredPostStructList.remove(at: 0)
                
                self.tableOfPostStructs = filteredPostStructList
                
                /*
                 for postStructListEntry in postStructList
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
                 */
                
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
                //NOTE: seems to be one empty postStruct when none are found
                self.tableOfPostStructs.remove(at: 0)
                
                let alertController = UIAlertController(title: "Nothing to report", message: "No reportable posts found nearby", preferredStyle: UIAlertControllerStyle.alert)
                
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
            }
            
            var printTableOfPostStructCount = "tableOfPostStructCount = "
            printTableOfPostStructCount.append(String(self.tableOfPostStructs.count))
            print(printTableOfPostStructCount)
            
            self.tblNearbyPosts.reloadData()
            
        }
        
        
    }
    
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return tableOfPostStructs.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NearbyPostsTableViewCell
        
        cell.lblCellPostMessage.text = tableOfPostStructs[indexPath.row].message
        cell.btnCellPostReport.tag = indexPath.row
        cell.btnCellPostReport.addTarget(self, action: #selector(NearbyPostsViewController.reportPostMessage), for: .touchUpInside)
        
        return cell
    }
    
    @IBAction func reportPostMessage(sender: UIButton)
    {
        //note: sender.tag should be the row index of table
        
        //TODO: Delete post message in database
        
        //temp result of button
        print("sender.tag = ")
        print(sender.tag)
        
        
        let request = NSMutableURLRequest(url: NSURL (string: "http://njaimes2.create.stedwards.edu/helpem/createVote.php")! as URL)
        request.httpMethod = "POST"
        
        let postString = "a=\(tableOfPostStructs[sender.tag].id)&b=\(activeUsername)"
        //let postString = "a=\(txtUsername.text!)&b=\(txtPassword.text!)"
        
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
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
            
            if String(describing: responseString!).range(of:"vote successfully added") != nil
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
                self.tableOfPostStructs.remove(at: sender.tag)
                //self.tblMyPosts.reloadData()
                //print("got here!!!")
                //activeUsername = queryUsername
                //self.performSegue(withIdentifier: "CreateAccountToMapSegue", sender: nil)
                
                //var postStructList = self.getPostStructListFromResponseString(responseString: theResponseString)
                
                //NOTE: weird bug in getPostStructListFromResponseString func that has the first index as inl for all entries
                //postStructList.remove(at: 0)
                
                //self.printPostStructList(postStructList: postStructList)
                
                //self.tableOfPostStructs = postStructList
                
                /*
                 for postStructListEntry in postStructList
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
                 */
                
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
                let alertController = UIAlertController(title: "Error", message: "Report Unsuccessful", preferredStyle: UIAlertControllerStyle.alert)
                
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
            }
            
            self.tblNearbyPosts.reloadData()
            
        }
        
        
        
    }
    
    /*
     public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
     {
     if editingStyle == UITableViewCellEditingStyle.delete
     {
     //TODO: Remove post entry from datbase
     tblMyPosts.reloadData()
     }
     }
     */
    
    /*
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    */
    
    override var prefersStatusBarHidden: Bool {
        return true
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
