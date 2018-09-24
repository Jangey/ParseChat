//
//  ChatViewController.swift
//  Parse Chat
//
//  Created by Jangey Lu on 9/23/18.
//  Copyright © 2018 Jangey Lu. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController {

    @IBOutlet weak var chatMessageField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func tapSend(_ sender: Any) {
        
         let chatMessage = PFObject(className: "Message")
         chatMessage["text"] = chatMessageField.text ?? ""
         chatMessage.saveInBackground { (success, error) in
         if success {
         print("The message was saved!")
         } else if let error = error {
         print("Problem saving message: \(error.localizedDescription)")
            }
        }
    }
    
    
    @IBAction func tapLogout(_ sender: Any) {
        // set user is logout
        PFUser.logOut()
        print("Loged out Success!")
        
        let signInPage = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let appDelegate = UIApplication.shared.delegate
        appDelegate?.window??.rootViewController = signInPage
    }
    
    

}
