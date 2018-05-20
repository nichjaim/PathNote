//
//  MyPostsViewController.swift
//  PathNote
//
//  Created by Nicholas Jaimes on 12/21/17.
//  Copyright © 2017 Nicholas Jaimes. All rights reserved.
//

import UIKit

class MyPostsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tblMyPosts: UITableView!
    
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
    
    
    
    
    override func viewDidAppear(_ animated: Bool)
    {
        
        let request = NSMutableURLRequest(url: NSURL (string: "http://njaimes2.create.stedwards.edu/helpem/getUserPosts.php")! as URL)
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
                
                self.tableOfPostStructs = postStructList
                
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
                //NOTE: seems to be an empty postStruct when none found
                self.tableOfPostStructs.remove(at: 0)
                
                let alertController = UIAlertController(title: "No Posts", message: "Current user has not posted anything", preferredStyle: UIAlertControllerStyle.alert)
                
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
            }
            
            self.tblMyPosts.reloadData()
            
        }
        
        
    }
    
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        print("numOfRows func postStruct table list")
        printPostStructList(postStructList: tableOfPostStructs)
        print("------end of numOfRows func postStruct table list------")
        return tableOfPostStructs.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyPostsTableViewCell
        
        cell.lblCellPostMessage.text = tableOfPostStructs[indexPath.row].message
        cell.btnCellPostDelete.tag = indexPath.row
        cell.btnCellPostDelete.addTarget(self, action: #selector(MyPostsViewController.deletePostMessage), for: .touchUpInside)
        
        return cell
    }
    
    @IBAction func deletePostMessage(sender: UIButton)
    {
        //note: sender.tag should be the row index of table
        
        //TODO: Delete post message in database
        
        //temp result of button
        print("sender.tag = ")
        print(sender.tag)
        
        
        let request = NSMutableURLRequest(url: NSURL (string: "http://njaimes2.create.stedwards.edu/helpem/deletePost.php")! as URL)
        request.httpMethod = "POST"
        
        let postString = "a=\(tableOfPostStructs[sender.tag].id)"
        
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
            
            if String(describing: responseString!).range(of:"record successfully deleted") != nil
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
                let alertController = UIAlertController(title: "Error", message: "Delete Unsuccessful", preferredStyle: UIAlertControllerStyle.alert)
                
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
            }
            
            self.tblMyPosts.reloadData()
            
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
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
