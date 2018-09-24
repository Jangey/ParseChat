//
//  LoginViewController.swift
//  Parse Chat
//
//  Created by Jangey Lu on 9/23/18.
//  Copyright © 2018 Jangey Lu. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    //let alertController = UIAlertController(title: "Title", message: "Message", preferredStyle: .alert)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func tapSignUp(_ sender: Any) {
        let newUser = PFUser()
        
        newUser.username = usernameField.text
        newUser.password = passwordField.text
        
        newUser.signUpInBackground { (success: Bool
            , error: Error?) in
            if let error = error {
                print(error.localizedDescription)
                self.errorPage(title: "title", message: "message")
            } else {
                print("User Registered successfully")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
    }
    
    @IBAction func tapLogin(_ sender: Any) {
        PFUser.logInWithUsername(inBackground: usernameField.text!, password: passwordField.text!) { (user: PFUser?
            , error: Error?) in
            
            if user == nil {
                self.invaildInput(title: "title", message: "message")
            } else {
                print("Loged in Success!")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
    }
    
    func invaildInput (title: String, message: String) {
        let alertController = UIAlertController(title: "Invaild input", message:
            "Please check username or password is correct.", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func errorPage (title: String, message: String) {
        let alertController = UIAlertController(title: "Error", message:
            "Something error, please try again.", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}
