//
//  CreateAccountViewController.swift
//  PathNote
//
//  Created by Nicholas Jaimes on 10/30/17.
//  Copyright © 2017 Nicholas Jaimes. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        /*
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        */
        
        /*
        self.txtUsername.delegate = self as? UITextFieldDelegate;
        self.txtPassword.delegate = self as? UITextFieldDelegate;
        self.txtReEnterPassword.delegate = self as? UITextFieldDelegate;
        */
        
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
    /*
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }*/
    
    /*
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    */
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBOutlet weak var txtUsername: UITextField!
    
    
    @IBOutlet weak var txtPassword: UITextField!
    
    
    @IBOutlet weak var txtReEnterPassword: UITextField!
    
    
    func wipeAllTextInputs()
    {
        txtUsername.text = ""
        txtPassword.text = ""
        txtReEnterPassword.text = ""
    }
    
    func wipePasswordTextInputs()
    {
        txtPassword.text = ""
        txtReEnterPassword.text = ""
    }
    
    func getUsernameFromResponseString(responseString: String) -> String
    {
        var returnValue = ""
        var singleQuotationCount = 0
        
        for character in responseString
        {
            if character == "'"
            {
                singleQuotationCount += 1
            }
            
            if singleQuotationCount == 1
            {
                returnValue.append(character)
            }
            
            if singleQuotationCount >= 2
            {
                returnValue.remove(at: returnValue.startIndex)
                break
            }
        }
        
        return returnValue
    }
    
    @IBAction func btnCreateAccount(_ sender: Any)
    {
        
        if (txtUsername.text == "" || txtPassword.text == "" || txtReEnterPassword.text == "")
        {
            let alertController = UIAlertController(title: "Empty Fields", message: "You have not filled out some of the fields yet", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            
            return
        }
        
        //checks if the re-entered password is same as the password
        if (txtPassword.text != txtReEnterPassword.text)
        {
            wipePasswordTextInputs()
            let alertController = UIAlertController(title: "Passwords Do Not Match", message: "The passwords you entered in the password fields do not match each other", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            
            return
        }
        
        let request = NSMutableURLRequest(url: NSURL (string: "http://njaimes2.create.stedwards.edu/helpem/createUser.php")! as URL)
        request.httpMethod = "POST"
        
        let postString = "a=\(txtUsername.text!)&b=\(txtPassword.text!)"
        
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        //var wasQuerySucessful = false
        //var responseString2 = ""
        
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
                let theResponseString = String(describing: responseString!)
                queryUsername = self.getUsernameFromResponseString(responseString: theResponseString)
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
                activeUsername = queryUsername
                self.performSegue(withIdentifier: "CreateAccountToMapSegue", sender: nil)
            }
            else if queryResult == "DUPLICATE"
            {
                self.wipeAllTextInputs()
                
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
