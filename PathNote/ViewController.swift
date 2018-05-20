//
//  ViewController.swift
//  PathNote
//
//  Created by Nicholas Jaimes on 10/27/17.
//  Copyright © 2017 Nicholas Jaimes. All rights reserved.
//

import UIKit

var activeUsername = ""

var messageToPost = ""

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        /*
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
 */
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        /*
        let request = NSMutableURLRequest(url: NSURL (string: "http://njaimes2.create.stedwards.edu/helpem/clean.php")! as URL)
        request.httpMethod = "POST"
        
        //let postString = "a=\(txtUsername.text!)&b=\(txtPassword.text!)"
        
        //request.httpBody = postString.data(using: String.Encoding.utf8)
        
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
            
            if String(describing: responseString!).range(of:"Clean Successful") != nil
            {
                //self.performSegue(withIdentifier: "MapSegue", sender: nil)
                queryResult = "FOUND"
                //let theResponseString = String(describing: responseString!)
                //queryUsername = self.getUsernameFromResponseString(responseString: theResponseString)
            }
                /*else if String(describing: responseString!).range(of:"Duplicate entry") != nil
                 {
                 /*
                 let alertController = UIAlertController(title: "Username already in use", message: "Please choose a different username for your account", preferredStyle: UIAlertControllerStyle.alert)
                 
                 alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                 
                 self.present(alertController, animated: true, completion: nil)
                 */
                 queryResult = "DUPLICATE"
                 }*/
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
            if queryResult == "FOUND"
            {
                //activeUsername = self.txtUsername.text!
                //self.performSegue(withIdentifier: "LoginToMapSegue", sender: nil)
            }
                /*else if queryResult == "DUPLICATE"
                 {
                 //self.wipeAllTextInputs()
                 
                 let alertController = UIAlertController(title: "Username already in use", message: "Please choose a different username for your account", preferredStyle: UIAlertControllerStyle.alert)
                 
                 alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                 
                 self.present(alertController, animated: true, completion: nil)
                 }*/
            else
            {
                let alertController = UIAlertController(title: "Clean Failed", message: "User post cleaning process failed", preferredStyle: UIAlertControllerStyle.alert)
                
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
                
                //self.txtUsername.text = ""
                //self.txtPassword.text = ""
            }
        }
        */
        
        cleanDatabase(queryToRun: "Expired")
        cleanDatabase(queryToRun: "Reported")
    }

    func cleanDatabase(queryToRun: String)
    {
        let request = NSMutableURLRequest(url: NSURL (string: "http://njaimes2.create.stedwards.edu/helpem/clean.php")! as URL)
        request.httpMethod = "POST"
        
        //let postString = "a=\(txtUsername.text!)&b=\(txtPassword.text!)"
        let postString = "a=\(queryToRun)"

        
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
            
            if String(describing: responseString!).range(of:"Clean Successful") != nil
            {
                //self.performSegue(withIdentifier: "MapSegue", sender: nil)
                queryResult = "FOUND"
                //let theResponseString = String(describing: responseString!)
                //queryUsername = self.getUsernameFromResponseString(responseString: theResponseString)
            }
                /*else if String(describing: responseString!).range(of:"Duplicate entry") != nil
                 {
                 /*
                 let alertController = UIAlertController(title: "Username already in use", message: "Please choose a different username for your account", preferredStyle: UIAlertControllerStyle.alert)
                 
                 alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                 
                 self.present(alertController, animated: true, completion: nil)
                 */
                 queryResult = "DUPLICATE"
                 }*/
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
            if queryResult == "FOUND"
            {
                //activeUsername = self.txtUsername.text!
                //self.performSegue(withIdentifier: "LoginToMapSegue", sender: nil)
            }
                /*else if queryResult == "DUPLICATE"
                 {
                 //self.wipeAllTextInputs()
                 
                 let alertController = UIAlertController(title: "Username already in use", message: "Please choose a different username for your account", preferredStyle: UIAlertControllerStyle.alert)
                 
                 alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                 
                 self.present(alertController, animated: true, completion: nil)
                 }*/
            else
            {
                let alertController = UIAlertController(title: "Clean Failed", message: "\(queryToRun) User post cleaning process failed", preferredStyle: UIAlertControllerStyle.alert)
                
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
                
                //self.txtUsername.text = ""
                //self.txtPassword.text = ""
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    */
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    @IBOutlet weak var txtUsername: UITextField!
    
    
    @IBOutlet weak var txtPassword: UITextField!
    
    
    @IBAction func btnLogin(_ sender: Any) {
        
        if (txtUsername.text == "" || txtPassword.text == "")
        {
            let alertController = UIAlertController(title: "Empty Fields", message: "You have not filled out some of the fields yet", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            
            return
        }
        
        let request = NSMutableURLRequest(url: NSURL (string: "http://njaimes2.create.stedwards.edu/helpem/login.php")! as URL)
        request.httpMethod = "POST"
        
        let postString = "a=\(txtUsername.text!)&b=\(txtPassword.text!)"
        
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
            
            if String(describing: responseString!).range(of:"Exists") != nil
            {
                //self.performSegue(withIdentifier: "MapSegue", sender: nil)
                queryResult = "FOUND"
                //let theResponseString = String(describing: responseString!)
                //queryUsername = self.getUsernameFromResponseString(responseString: theResponseString)
            }
            /*else if String(describing: responseString!).range(of:"Duplicate entry") != nil
            {
                /*
                 let alertController = UIAlertController(title: "Username already in use", message: "Please choose a different username for your account", preferredStyle: UIAlertControllerStyle.alert)
                 
                 alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                 
                 self.present(alertController, animated: true, completion: nil)
                 */
                queryResult = "DUPLICATE"
            }*/
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
            if queryResult == "FOUND"
            {
                activeUsername = self.txtUsername.text!
                self.performSegue(withIdentifier: "LoginToMapSegue", sender: nil)
            }
            /*else if queryResult == "DUPLICATE"
            {
                //self.wipeAllTextInputs()
                
                let alertController = UIAlertController(title: "Username already in use", message: "Please choose a different username for your account", preferredStyle: UIAlertControllerStyle.alert)
                
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
            }*/
            else
            {
                let alertController = UIAlertController(title: "Invalid Infomration", message: "Account with this login inputs was not found", preferredStyle: UIAlertControllerStyle.alert)
                
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
                
                self.txtUsername.text = ""
                self.txtPassword.text = ""
            }
        }
        
    }
    

}

