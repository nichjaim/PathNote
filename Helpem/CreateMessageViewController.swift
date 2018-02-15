//
//  CreateMessageViewController.swift
//  Helpem
//
//  Created by Nicholas Jaimes on 11/9/17.
//  Copyright © 2017 Nicholas Jaimes. All rights reserved.
//

import UIKit

class CreateMessageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    @IBOutlet weak var txtMessage: UITextView!
    
    
    @IBAction func btnNext(_ sender: Any)
    {
        txtMessage.text = txtMessage.text.replacingOccurrences(of: "{", with: "")
        txtMessage.text = txtMessage.text.replacingOccurrences(of: "}", with: "")
        
        if txtMessage.text == ""
        {
            let alertController = UIAlertController(title: "No Message", message: "Please create a message before moving on", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            messageToPost = txtMessage.text
            
            self.performSegue(withIdentifier: "MessageToTimeSegue", sender: nil)
        }
    }
    

}
